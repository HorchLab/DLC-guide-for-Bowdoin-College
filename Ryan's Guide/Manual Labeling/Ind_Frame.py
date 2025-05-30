import pandas as pd

"""
The excel sheets before were given using a start, end, category system. (Ryan's manual labels)

With the new labeling script, the outputs were individual frames instead with state and state_label. 

Use Ind_Frame.py as a way to convert my manual labels to formats consistent with the outputs of the labeling script.
All files that used the script were relabeled _ALTERED.csv. 
"""

# Read the input CSV
input_path = "_____.csv"
output_path = "_____.csv"
df = pd.read_csv(input_path)
print(df.head()) 

# Define the category mappings
category_map = {
    0: {"state": 0, "state_label": "not flying"},
    1: {"state": 2, "state_label": "flying"},
    2: {"state": 1, "state_label": "transition"}
}

# Generate expanded rows
new_rows = []
for _, row in df.iterrows():
    start = int(row['Start'])
    end = int(row['End'])
    category = int(row['Category:'])
    
    # Get state and label from mapping
    state = category_map[category]["state"]
    state_label = category_map[category]["state_label"]
    
    # Add a row for each frame in [Start, End]
    for frame in range(start, end + 1):
        new_rows.append({
            "frame": frame,
            "state": state,
            "state_label": state_label
        })

# Save as new CSV
pd.DataFrame(new_rows).to_csv(output_path, index=False)
print(f"Done! Check {output_path}")