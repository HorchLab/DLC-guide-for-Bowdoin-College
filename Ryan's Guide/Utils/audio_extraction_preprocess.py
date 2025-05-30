import ffmpeg
import opensoundscape as opso # For audio analysis
import numpy as np
import pandas as pd
import argparse
from typing import List
import os

RESAMPLE = False
VERBOSE = False
FFMPEG_LOGLEVEL = 'info'
INFO = "INFO"
ERR = "ERROR"
WARNING = "WARNING"
    
def out_msg(msg, tag = None):
    if tag:
        if tag == INFO and not VERBOSE: return;
        print(f"[preprocess.py - {tag}] {msg}")
    else: 
        print(f"[preprocess.py] {msg}")

def extract_audio(audio_file, output_name, target_frames = None):
    out_msg(f"Starting to extract audio from \'{audio_file}\'")
    channels = opso.audio.load_channels_as_audio(audio_file)
    duration = channels[0].duration
    sample_rate = channels[0].sample_rate
    out_msg(f"Audio duration: {duration} (in seconds), check if it matches the video duration!", INFO)
    out_msg(f"Sample rate: {sample_rate} Hz", INFO)

    out_msg("Creating spectrogram", INFO)
    spectrograms: List[opso.Spectrogram] = [opso.Spectrogram.from_audio(channel) for channel in channels]

    out_msg(f"Spectrograms duration: {spectrograms[0].duration}. Result might be shorter than audio because of the nature of FFT", INFO)

    l_spec, r_spec = spectrograms

    def extract_pitches_and_db(spec): 
        freqs = spec.frequencies
        spec_arr = spec.spectrogram
        pitches = freqs[np.argmax(spec_arr, axis = 0)]
        decibels = np.max(spec_arr, axis=0)
        return pitches, decibels
    
    l_pitches, l_db = extract_pitches_and_db(l_spec)
    r_pitches, r_db = extract_pitches_and_db(r_spec)

    results = np.swapaxes(np.array([l_pitches, l_db, r_pitches, r_db]), 0, 1)

    out_msg(f"Extracted pitch and db for both channels, result shape: {results.shape}", INFO)

    results_df = pd.DataFrame(results, l_spec.window_start_times, ("Pitches_L", "dB_L", "Pitches_R", "dB_R"))
    out_msg("CSV Preview: \n" + results_df.head(5).to_string(), INFO)

    if RESAMPLE: 
        out_msg("Output ready to be resampled, but will not be resampled at this point.")
        out_msg("Resample haven't been developed yet.", WARNING)
    
    if target_frames: 
        out_msg("Supplied argument target_frame is not used because RESAMPLE flag is False", INFO)

    # If there's no high frequency pitch detected throughout the dataframe, produce a warning message 
    # TODO: work on this
    if False: 
        out_msg("All detected pitches are not in the ultrasound range (15kHz), check recording if this is not intented", WARNING)
        out_msg("All detected pitches are not in the ultrasound range (15kHz), check recording if this is not intented", WARNING)
        out_msg("All detected pitches are not in the ultrasound range (15kHz), check recording if this is not intented", WARNING)

    results_df.to_csv(output_name, index=True)
    out_msg(f"Output saved as {output_name}")
    return

def parse_arguments():
    parser = argparse.ArgumentParser(
            description='This script help preparing videos for audio analysis by extracting audio from video files and saving them as .wav files. It also extracts pitch and decibel information from the audio and saves them as .csv files.',
            epilog='Example usage: python %(prog)s -i /path/to/video.mp4 -o /path/to/output_dir -v \n OR: python %(prog)s -i /path/to/video_dir -o /path/to/output_dir -v \n OR: python %(prog)s -i /path/to/audio.wav -o /path/to/output_dir -v',
            formatter_class=argparse.RawDescriptionHelpFormatter
        )
    parser.add_argument('-i', '--input', nargs='+', help='Input file(s) or directory(ies)', required=True)
    parser.add_argument('-o', '--output', type=str, help='Output directory', required=True)
    parser.add_argument('-v', '--verbose', action='store_true', help='Enable verbose mode')
    parser.add_argument('-r', '--resample', action='store_true', help='Enable resampling')
    parser.add_argument('--verbose-ffmpeg', action='store_true', default=False, dest='verbose_ffmpeg', help='Enable verbose mode for ffmpeg')
    parser.add_argument('--highpass-hz', type=int, default=5000, help='Highpass filter frequency')
    parser.add_argument('--no-skip', action='store_false', default=True, dest='skip_exist', help='Do not skip existing .csv (overwrite)')
    parser.add_argument('--no-highpass', action='store_false', default=True, dest='highpass', help='Do not apply highpass filter')
    parser.add_argument('--just-mp4', action='store_false', default=True, dest='audio_extraction', help='Do not extract and analyze audio from video files, just convert them to .mp4 for DeepLabCut')
    parser.add_argument('--target-frames', type=int, help='Target frame count for resampling')
    return parser.parse_args()

def __main__():
    global RESAMPLE
    global VERBOSE
    global FFMPEG_LOGLEVEL
    args = parse_arguments()
    input_files = args.input
    output_dir = args.output
    highpass = args.highpass
    highpass_hz = args.highpass_hz
    skip_exist = args.skip_exist
    resample = args.resample
    verbose = args.verbose
    verbose_ffmpeg = args.verbose_ffmpeg
    target_frames = args.target_frames
    audio_extraction = args.audio_extraction
    RESAMPLE = True if resample else False
    VERBOSE = True if verbose else False
    FFMPEG_LOGLEVEL = 'verbose' if verbose_ffmpeg else 'warning'
    
    out_msg(f"Start with the following argument: \n\tinput: {input_files},\n\t output: {output_dir}, \n\t highpass: {highpass}, \n\t highpass_hz: {highpass_hz}, \n\t skip_exist: {skip_exist}, \n\t resample: {resample}, \n\t verbose: {verbose}, \n\t verbose_ffmpeg: {verbose_ffmpeg}, \n\t target_frames: {target_frames}")

    if not output_dir.endswith("/"): 
        out_msg("Appended \'/\' to the end of the output directory. ", INFO)
        output_dir += "/"

    inputs = []

    # Parse directories and files. 
    for file in input_files:
        if os.path.isdir(file):
            # Handle directory
            files = os.listdir(file)
            dir = file
            for f in files:
                basename = os.path.basename(f)
                basename = os.path.splitext(basename)[0]
                if (os.path.exists(os.path.join(output_dir, basename + ".csv")) or os.path.exists(os.path.join(output_dir, basename + "_lowcut.csv"))) and skip_exist: 
                    out_msg(f"Skipping {f} because a corresponding .csv file already exists", INFO)
                    continue
                if f.endswith('.mkv'): 
                    if os.path.exists(os.path.join(dir, f.replace('mkv', 'mp4'))): 
                        out_msg(f"Skipping video {f} because a corresponding .mp4 file already exists", INFO)
                        continue
                    else: 
                        out_msg(f"Converting video file {f} to mp4", INFO)
                        out_msg("Converting without re-encoding, if ffmpeg raised exception, check your recording codec or run ffmpeg outside of this script. ", WARNING)
                        # This ffmpeg step is put here so that if you don't need audio extraction, I can just skip steps below. 
                        (
                            ffmpeg
                            .input(os.path.join(dir, f), loglevel = FFMPEG_LOGLEVEL)
                            .output(os.path.join(dir, f.replace('.mkv', '.mp4')), codec='copy')
                            .overwrite_output()
                            .run()
                        )
                        inputs.append(os.path.join(dir, f.replace('.mkv', '.mp4')))
                        out_msg(f"Converted video file {f} to mp4: {os.path.join(file, f.replace('.mkv', '.mp4'))}")
                if f.endswith('.mp4'): 
                    if os.path.exists(os.path.join(dir, f.replace('.mp4', '.wav'))) or os.path.exists(os.path.join(file, f.replace('.mp4', '_lowcut.wav'))):
                        out_msg(f"Skipping video {f} because a corresponding .wav file already exists", INFO)
                        continue
                    else: 
                        inputs.append(os.path.join(dir, f))
                if f.endswith('.wav'):
                    if os.path.exists(os.path.join(dir, f.replace('.wav', '_lowcut.wav'))): 
                        out_msg(f"Skipping audio {f} because a corresponding _lowcut.wav file already exists", INFO)
                        continue
                    inputs.append(os.path.join(file, f))
        elif file.endswith('.mp4') or file.endswith('.wav'):
            inputs.append(file)

    input_files = inputs
    if not audio_extraction: 
        out_msg("Skipped audio extraction and analysis, quitting.")
        return
    out_msg(f"Found {len(input_files)} files to process.")
    out_msg("File List:\n\t" + '\n\t'.join(input_files), INFO)
    for i, file in enumerate(input_files):
        if file.endswith('.mp4'):
            out_msg(f"Processing video file: {file}", INFO)
            out_msg(f"extracting audio file (ends in wav)", INFO)
            original_audio_name = file.replace('.mp4', '.wav')
            (
                ffmpeg
                .input(file, loglevel = FFMPEG_LOGLEVEL)
                .output(original_audio_name, format='wav', map='0:a')
                .run()
            )
            if highpass: 
                out_msg("Applying highpass filter", INFO)
                filtered_audio_name = file.replace('.mp4', '_lowcut.wav')
                (
                    ffmpeg
                    .input(original_audio_name, loglevel = FFMPEG_LOGLEVEL)
                    .audio
                    .filter('highpass', f=highpass_hz)
                    .output(filtered_audio_name, format='wav')
                    .run()
                )
                audio_file = filtered_audio_name
            else: 
                audio_file = original_audio_name
            if resample: 
                out_msg("Resample not implemented yet, frame_count does not get updated!!!", ERR)
        elif file.endswith('.wav'):
            out_msg(f"Processing audio file: {file}", INFO)
            if RESAMPLE: out_msg("Resample would not work because target frame is not supplied. ", WARNING)
            target_frames = None
            if highpass and not file.endswith('lowcut.wav'): 
                out_msg("Applying highpass filter...", INFO)
                filtered_audio_name = file.replace('.wav', '_lowcut.wav')
                (
                    ffmpeg
                    .input(file, loglevel = FFMPEG_LOGLEVEL)
                    .audio
                    .filter('highpass', f=highpass_hz)
                    .output(filtered_audio_name, format='wav')
                    .run()
                )
                audio_file = filtered_audio_name
            else: 
                audio_file = file
        else:
            out_msg(f"Unsupported file format: {file}", ERR)
            continue
        output_name = os.path.basename(audio_file)
        output_name = os.path.splitext(output_name)[0]
        output_name = output_dir + output_name + '.csv'
        
        if verbose:
            out_msg(f"Extracting from audio file: {audio_file}", INFO)
        if not resample: target_frames = None
        extract_audio(audio_file, output_name, target_frames)

if __name__ == "__main__":
    __main__()
