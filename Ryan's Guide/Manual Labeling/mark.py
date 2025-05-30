import sys
import os
import csv
import subprocess
import time
import numpy as np
import imageio
import cv2
from pynput import keyboard
from threading import Lock
from collections import deque

class FrameBuffer:
    def __init__(self, video_path, buffer_size=200):
        self.cap = cv2.VideoCapture(video_path, cv2.CAP_FFMPEG)
        self.cap.set(cv2.CAP_PROP_HW_ACCELERATION, cv2.VIDEO_ACCELERATION_ANY)
        self.buffer_size = buffer_size
        self.frame_buffer = deque(maxlen=buffer_size)
        self.buffer_start_frame = 0
        self.seek_count = 0
        self._fill_buffer()

    def _fill_buffer(self):
        while len(self.frame_buffer) < self.buffer_size:
            ret, frame = self.cap.read()
            if not ret:
                break
            self.frame_buffer.append(frame)

    def get_frame(self, target_frame):
        if target_frame < 0 or target_frame >= int(self.cap.get(cv2.CAP_PROP_FRAME_COUNT)):
            return None

        # Handle sequential forward access
        if target_frame == self.buffer_start_frame + len(self.frame_buffer):
            ret, frame = self.cap.read()
            if ret:
                self.frame_buffer.append(frame)
                self.buffer_start_frame += 1
                return frame

        # Check if frame is in buffer
        buffer_end = self.buffer_start_frame + len(self.frame_buffer) - 1
        if self.buffer_start_frame <= target_frame <= buffer_end:
            offset = target_frame - self.buffer_start_frame
            return self.frame_buffer[offset]

        # Need to seek
        self.seek_count += 1
        self.cap.set(cv2.CAP_PROP_POS_FRAMES, target_frame)
        self.frame_buffer.clear()
        self._fill_buffer()
        self.buffer_start_frame = target_frame
        return self.frame_buffer[0] if self.frame_buffer else None

    def release(self):
        self.cap.release()

DEFAULT_STATES = {
    -1: "unlabeled",
    0: "not flying",
    1: "transition",
    2: "flying"
}

STATE_COLORS = {
    -1: (128, 128, 128),
    0: (0, 0, 255),
    1: (0, 255, 255),
    2: (0, 255, 0)
}

USE_HARDWARE_ACCEL = True
if USE_HARDWARE_ACCEL:
    os.environ["OPENCV_FFMPEG_CAPTURE_OPTIONS"] = "hwaccel;videotoolbox"

OVERVIEW_BAR_HEIGHT = 50
DETAIL_BAR_HEIGHT = 50
INITIAL_HOLD_DELAY = 0.3
FAST_ADVANCE_DELAY = 0.03
DISPLAY_EVERY = 2  # Show every 2nd frame during fast advance

def draw_progress_bars(frame, labels, current_frame, nframes, vid_width, fps):
    overview_bar = np.zeros((OVERVIEW_BAR_HEIGHT, vid_width, 3), dtype=np.uint8)

    for x in range(vid_width):
        frame_idx = int((x / vid_width) * nframes)
        state = labels.get(frame_idx, -1)
        overview_bar[:, x] = STATE_COLORS[state]

    indicator_x = int((current_frame / nframes) * vid_width)
    cv2.line(overview_bar, (indicator_x, 0), (indicator_x, OVERVIEW_BAR_HEIGHT), (255, 255, 255), 2)

    detail_bar = np.zeros((DETAIL_BAR_HEIGHT, vid_width, 3), dtype=np.uint8)
    start_frame = max(0, current_frame - int(5 * fps))
    end_frame = min(nframes, current_frame + int(5 * fps))
    window_size = end_frame - start_frame

    if window_size > 0:
        for x in range(vid_width):
            frame_idx = start_frame + int((x / vid_width) * window_size)
            state = labels.get(frame_idx, -1)
            detail_bar[:, x] = STATE_COLORS[state]

        detail_indicator_x = int(((current_frame - start_frame) / window_size) * vid_width)
        cv2.line(detail_bar, (detail_indicator_x, 0), (detail_indicator_x, DETAIL_BAR_HEIGHT), (255, 255, 255), 2)

        start_time = start_frame / fps
        end_time = end_frame / fps
        cv2.putText(detail_bar, f"{start_time:.1f}s", (10, DETAIL_BAR_HEIGHT-10),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.4, (255,255,255), 1)
        cv2.putText(detail_bar, f"{end_time:.1f}s", (vid_width-50, DETAIL_BAR_HEIGHT-10),
                   cv2.FONT_HERSHEY_SIMPLEX, 0.4, (255,255,255), 1)

    return np.vstack((frame, overview_bar, detail_bar))

def generate_review_video_ffmpeg(video_path, labels, fps, nframes, vid_width, vid_height):
    progress_bar_height = 50
    duration = nframes / fps

    progress_bar = np.zeros((progress_bar_height, vid_width, 3), dtype=np.uint8)
    for x in range(vid_width):
        frame_index = int(x / vid_width * nframes)
        state = labels.get(frame_index, -1)
        bgr_color = STATE_COLORS.get(state, (128, 128, 128))
        color = bgr_color[::-1]
        progress_bar[:, x, :] = color

    progress_bar_path = os.path.splitext(video_path)[0] + "_progress_bar.png"
    imageio.imwrite(progress_bar_path, progress_bar)
    print(f"Progress bar image saved to {progress_bar_path}")

    output_review = os.path.splitext(video_path)[0] + "_review.mp4"

    filter_complex = (
        f"[0:v]pad=iw:ih+{progress_bar_height}:0:0:color=black[bg]; "
        f"[bg][1:v]overlay=0:{vid_height}[ov]; "
        f"[ov]drawtext=text='|':"
        f"x=(w - tw) * (t / {duration}) - (tw/2):"
        f"y={vid_height} + ({progress_bar_height}/2) - {progress_bar_height//8}:"
        f"fontsize={int(progress_bar_height * 1.1)}:"
        "fontcolor=white@0.8:"
        "box=1:boxcolor=black@0.5:"
        "borderw=2:"
        "line_spacing=0"
    )

    cmd = [
        "ffmpeg",
        "-y",
        "-hwaccel", "auto",
        "-i", video_path,
        "-i", progress_bar_path,
        "-filter_complex", filter_complex,
        "-c:v", "h264_videotoolbox",
        "-b:v", "5000k",
        "-c:a", "copy",
        output_review
    ]
    print("Running ffmpeg command to generate review video:")
    print(" ".join(cmd))
    subprocess.run(cmd, check=True)
    print(f"Review video generated: {output_review}")

class KeyStateTracker:
    def __init__(self):
        self.lock = Lock()
        self.states = {
            keyboard.Key.space: False,
            keyboard.Key.left: False,
            keyboard.Key.right: False,
            keyboard.Key.esc: False,
            keyboard.KeyCode.from_char('q'): False,
            keyboard.KeyCode.from_char('0'): False,
            keyboard.KeyCode.from_char('1'): False,
            keyboard.KeyCode.from_char('2'): False,
            keyboard.KeyCode.from_char(','): False,
            keyboard.KeyCode.from_char('.'): False
        }

    def on_press(self, key):
        with self.lock:
            if key in self.states:
                self.states[key] = True
            elif hasattr(key, 'char'):
                if key.char in ['0', '1', '2', ',', '.', 'q']:
                    self.states[keyboard.KeyCode.from_char(key.char)] = True

    def on_release(self, key):
        with self.lock:
            if key in self.states:
                self.states[key] = False
            elif hasattr(key, 'char'):
                if key.char in ['0', '1', '2', ',', '.', 'q']:
                    self.states[keyboard.KeyCode.from_char(key.char)] = False

    def get_state(self, key):
        with self.lock:
            return self.states.get(key, False)

def main():
    if len(sys.argv) < 2:
        print("Usage: python label_video.py path/to/video.mp4")
        sys.exit(1)
    video_path = sys.argv[1]

    frame_buffer = FrameBuffer(video_path)
    cap = frame_buffer.cap

    print(f"Hardware acceleration status: {'Active' if cap.get(cv2.CAP_PROP_HW_ACCELERATION) > 0 else 'Inactive'}")

    fps = cap.get(cv2.CAP_PROP_FPS)
    nframes = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    vid_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    vid_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

    key_tracker = KeyStateTracker()
    listener = keyboard.Listener(
        on_press=key_tracker.on_press,
        on_release=key_tracker.on_release
    )
    listener.start()

    labels = {}
    current_frame = 0
    last_frame_time = time.time()
    held_number = None
    hold_start_time = 0
    display_counter = 0

    print("Controls:")
    print("  → / ← : Next/Previous frame")
    print("  ,/. : Jump 5 seconds")
    print("  Space: Hold to auto-play")
    print("  0-2: Label current frame (hold for auto-label)")
    print("  Q: Quit and export")

    cv2.namedWindow("Video Labeling Tool", cv2.WINDOW_NORMAL)

    while True:
        # --- INPUT HANDLING FIRST ---
        now = time.time()
        elapsed = now - last_frame_time
        frame_delay = 1 / fps

        # Reset control flags
        should_advance = False
        fast_advance = False
        held_this_frame = False

        # Handle quit commands
        if key_tracker.get_state(keyboard.Key.esc) or key_tracker.get_state(keyboard.KeyCode.from_char('q')):
            break

        # Spacebar handling (normal speed)
        if key_tracker.get_state(keyboard.Key.space):
            should_advance = True

        # Number key handling (fast labeling)
        for num, key in enumerate([keyboard.KeyCode.from_char(str(n)) for n in range(3)]):
            if key_tracker.get_state(key):
                held_this_frame = True
                labels[current_frame] = num  # Label current frame

                if held_number != num:
                    # New key press - immediate advance
                    held_number = num
                    hold_start = now
                    # current_frame = min(current_frame + 1, nframes - 1)
                    last_frame_time = now
                else:
                    # Continuing hold - check for fast advance
                    if now - hold_start > INITIAL_HOLD_DELAY:
                        fast_advance = True
                break

        # Reset states if no keys are pressed
        if not held_this_frame:
            held_number = None
            fast_advance = False

        # Frame advancement logic
        if fast_advance:
            # Ultra-fast labeling mode
            if (now - last_frame_time) >= FAST_ADVANCE_DELAY:
                current_frame = min(current_frame + 1, nframes - 1)
                labels[current_frame] = held_number
                last_frame_time = now
        elif should_advance:
            # Normal playback speed
            if elapsed >= frame_delay:
                current_frame = min(current_frame + 1, nframes - 1)
                last_frame_time = now

        # --- ARROW KEY HANDLING ---
        # print(f"\nCurrent key states:")
        # print(f"Left: {key_tracker.get_state(keyboard.Key.left)} | Right: {key_tracker.get_state(keyboard.Key.right)}")
        # print(f"Current frame before controls: {current_frame}")

        # Handle arrow key navigation
        if key_tracker.get_state(keyboard.Key.right):
            print("Processing RIGHT key press")
            current_frame = min(current_frame + 1, nframes - 1)
        if key_tracker.get_state(keyboard.Key.left):
            print("Processing LEFT key press")
            current_frame = max(0, current_frame - 1)

        # Handle jump controls
        if key_tracker.get_state(keyboard.KeyCode.from_char(',')):
            print("Processing COMMA key press")
            current_frame = max(0, current_frame - int(5 * fps))
        if key_tracker.get_state(keyboard.KeyCode.from_char('.')):
            print("Processing PERIOD key press")
            current_frame = min(nframes - 1, current_frame + int(5 * fps))

        # print(f"Current frame after controls: {current_frame}")

        # --- FRAME PROCESSING ---
        # Get frame AFTER handling inputs
        frame = frame_buffer.get_frame(current_frame)
        if frame is None:
            break

        # --- DISPLAY UPDATE ---
        # Only update display when needed
        if not (display_counter % DISPLAY_EVERY == 0 and held_number is not None):
            display = frame.copy()
            text = f"Frame: {current_frame}/{nframes-1}"
            state = labels.get(current_frame, -1)
            text += f" | State: {state} ({DEFAULT_STATES[state]})"
            color = STATE_COLORS.get(state, (255, 255, 255))
            cv2.putText(display, text, (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.7, color, 2)
            combined_frame = draw_progress_bars(display, labels, current_frame, nframes, vid_width, fps)
            cv2.imshow("Video Labeling Tool", combined_frame)

        display_counter += 1

        # --- FINAL EVENT PROCESSING ---
        # Handle OpenCV events last
        key = cv2.waitKey(1 if (fast_advance or should_advance) else 0)
        # print(f"waitKey returned: {key}")
        if key == ord('q'):
            break

    frame_buffer.release()
    cv2.destroyAllWindows()

    not_labelled = 0
    not_labelled_frames = []
    for i in range(nframes):
        if i not in labels:
            not_labelled += 1
            not_labelled_frames.append(i)
            labels[i] = -1

    if not_labelled != 0:
        print(f"{not_labelled} frame(s) detected as not labelled.")
        print(not_labelled_frames)

    csv_filename = os.path.splitext(video_path)[0] + "_labels.csv"
    with open(csv_filename, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["frame", "state", "state_label"])
        for i in range(nframes):
            state = labels[i]
            writer.writerow([i, state, DEFAULT_STATES.get(state, "unlabeled")])
    print(f"Labels exported to {csv_filename}")

    print("Generating review video...")
    generate_review_video_ffmpeg(video_path, labels, fps, nframes, vid_width, vid_height)
    print(f"Buffer efficiency: {nframes - frame_buffer.seek_count}/{nframes} frames served from cache")

if __name__ == "__main__":
    main()
