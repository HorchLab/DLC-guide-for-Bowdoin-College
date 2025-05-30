import pandas as pd
import numpy as np
import os
from math import acos, degrees

""" 
1. There are certain assumptions when using this file. 
    a. In the tiniest sound increment, there is 50ms of sound followed by 30ms of silence. 
    Converting by ms to frames is essentially 1:1. (I think the exact frame rate was 59.9 frames/sec but we 
    are rounding for ease).
    b. In the next grouping, there is approximately 1 sec of silence and 370 ms of sound bursts. I squashed this resolution of sound. 
    Anything that plays within 1 burst grouping / 1 amplitude group of bursts was labeled as playing 
    that sound even if the exact frame was just silence. 
    c. The logic of this file states that at the largest resolution, 
    there is about a 2.15 sec or ~129 frame gap before the next amplitude group bursting plays. 
    All frames before the first ultrasound plays is silence, followed by 50dB 18kHZ bursts, followed by ~129 frames of silence, 
    then 55db 18kHZ bursts, then ~129 frames of silence, etc. Thus, if a gap of ~129 frames or greater is noticed between ultrasound, 
    it moves the amplitude step by 5dB. 
2. See Assumptions.jpeg for a visual representation of the logic.
3. The relabel_silent_frames function is used to relabel silent frames that occur after the first left pass. 
    It preserves all silent frames before labeling begins and any silent frames that are not 0/silent.
    **This function needed to be added to the original code to ensure that silent frames are not relabeled incorrectly (it was having 
    some trouble otherwise)
"""

def relabel_silent_frames(df):
    """
    Relabels ONLY 0/silent frames occurring after first 50/left label appears.
    Preserves all 2/silent frames and any silent frames before labeling begins.
    """
    df = df.copy()
    
    # Find first occurrence of 50/left (where proper labeling begins)
    first_left_pass = df[(df['s_chunk'] == 50) & (df['s_side'] == 'left')].index.min()
    
    # If no left pass found, return original df
    if pd.isna(first_left_pass):
        return df
    
    # Iterate backwards from end to first_left_pass
    for i in range(len(df)-2, first_left_pass-1, -1):
        # Only target frames that are EXACTLY 0/silent
        if df.at[i, 's_chunk'] == 0 and df.at[i, 's_side'] == 'silent':
            next_chunk = df.at[i+1, 's_chunk']
            next_side = df.at[i+1, 's_side']
            
            # Only relabel if next frame isn't silent (0/silent or 2/silent)
            if not (next_chunk == 0 or next_side == 'silent') and \
               not (next_chunk == 2 and next_side == 'silent'):
                df.at[i, 's_chunk'] = next_chunk
                df.at[i, 's_side'] = next_side
    
    return df

def label_sequence(df, pitch_threshold=18000, max_gap=115):
    df = df.copy()
    df['s_chunk'] = 0
    df['s_side'] = 'silent'
    
    # State tracking
    LEFT_PASS = 1
    MID_SILENT = 2
    RIGHT_PASS = 3
    END_STATE = 4
    state = None
    current_chunk = 0
    last_target_idx = None
    current_chunk_start = None

    for idx, row in df.iterrows():
        if row['Pitches_combined'] == pitch_threshold:
            # State transitions
            if state is None:
                state = LEFT_PASS
                current_chunk = 50
                current_chunk_start = idx
            
            elif state == LEFT_PASS:
                gap = idx - last_target_idx if last_target_idx else float('inf')
                
                if gap > max_gap:
                    if current_chunk_start is not None and last_target_idx is not None:
                        df.loc[current_chunk_start:last_target_idx, 's_chunk'] = current_chunk
                        df.loc[current_chunk_start:last_target_idx, 's_side'] = 'left'
                    
                    if current_chunk == 90:
                        state = MID_SILENT
                        current_chunk = 2
                        if last_target_idx is not None:
                            df.loc[last_target_idx+1:idx-1, 's_chunk'] = 2
                            df.loc[last_target_idx+1:idx-1, 's_side'] = 'silent'
                        current_chunk_start = idx
                        continue
                    
                    df.loc[last_target_idx+1:idx-1, 's_chunk'] = 1
                    df.loc[last_target_idx+1:idx-1, 's_side'] = 'left'
                    current_chunk = min(current_chunk + 5, 90)
                    current_chunk_start = idx
            
            elif state == MID_SILENT:
                state = RIGHT_PASS
                current_chunk = 50
                current_chunk_start = idx
                # CRITICAL FIX: Immediately label first right target
                df.at[idx, 's_chunk'] = current_chunk
                df.at[idx, 's_side'] = 'right'
                last_target_idx = idx
                continue
            
            elif state == RIGHT_PASS:
                gap = idx - last_target_idx if last_target_idx else float('inf')
                if gap > max_gap:
                    if current_chunk_start is not None and last_target_idx is not None:
                        df.loc[current_chunk_start:last_target_idx, 's_chunk'] = current_chunk
                        df.loc[current_chunk_start:last_target_idx, 's_side'] = 'right'
                    
                    if current_chunk == 90:
                        state = END_STATE
                        current_chunk = 3
                        if last_target_idx is not None:
                            df.loc[last_target_idx+1:idx-1, 's_chunk'] = 3
                            df.loc[last_target_idx+1:idx-1, 's_side'] = 'end'
                        current_chunk_start = idx
                        continue
                    
                    df.loc[last_target_idx+1:idx-1, 's_chunk'] = -1
                    df.loc[last_target_idx+1:idx-1, 's_side'] = 'right'
                    current_chunk = 50 if current_chunk == 90 else current_chunk + 5
                    current_chunk_start = idx
            
            last_target_idx = idx
            df.at[idx, 's_chunk'] = current_chunk
            df.at[idx, 's_side'] = ('left' if state == LEFT_PASS else 
                                   'right' if state == RIGHT_PASS else 
                                   'end')
        
        elif state == MID_SILENT:
            df.at[idx, 's_chunk'] = 2
            df.at[idx, 's_side'] = 'silent'
        elif state == END_STATE:
            df.at[idx, 's_chunk'] = 3
            df.at[idx, 's_side'] = 'end'
    
    # Final chunk labeling
    if current_chunk_start is not None and last_target_idx is not None:
        if state == LEFT_PASS:
            df.loc[current_chunk_start:last_target_idx, 's_chunk'] = current_chunk
            df.loc[current_chunk_start:last_target_idx, 's_side'] = 'left'
            if current_chunk == 90:
                df.loc[last_target_idx+1:, 's_chunk'] = 2
                df.loc[last_target_idx+1:, 's_side'] = 'silent'
        elif state == RIGHT_PASS:
            df.loc[current_chunk_start:last_target_idx, 's_chunk'] = current_chunk
            df.loc[current_chunk_start:last_target_idx, 's_side'] = 'right'
            if current_chunk == 90:
                df.loc[last_target_idx+1:, 's_chunk'] = 3
                df.loc[last_target_idx+1:, 's_side'] = 'end'
    
    return df[['source_file', 'Frames', 'state_label', 'Pitches_combined', 's_chunk', 's_side']]

def process_multiple_files(output_file="pooled_results.csv"):
    """Process multiple files and pool results with ALL coordinate columns"""
    all_data = []
    
    for file in os.listdir():
        if file.endswith('_MERGED.csv'):
            print(f"Processing {file}...")
            df = pd.read_csv(file)
            
            # Ensure source_file column exists
            if 'source_file' not in df.columns:
                df['source_file'] = file
            
            # Apply labeling and relabeling to the FULL dataframe
            labeled = label_sequence(df)  # This returns only 6 columns by default
            relabeled = relabel_silent_frames(labeled)
            
            # Merge back with original coordinate columns
            coord_cols = [col for col in df.columns if '_x' in col or '_y' in col]
            result = pd.concat([
                relabeled[['source_file', 'Frames', 'state_label', 'Pitches_combined', 's_chunk', 's_side']],
                df[coord_cols]
            ], axis=1)
            
            all_data.append(result)
    
    if not all_data:
        print("No matching files found!")
        return
    
    pooled = pd.concat(all_data)
    pooled.to_csv(output_file, index=False)
    print(f"Pooled results saved to {output_file}")
    return pooled

if __name__ == "__main__":
    pooled_data = process_multiple_files()
