import os
import shutil

"""Moves csv and png files into their respective folders while leaving the mp4 alone"""

def copy_and_delete_csv_png(from_dir, dest_dir):
    # Ensure the destination directory exists
    os.makedirs(dest_dir, exist_ok=True)

    # List all files in the source directory
    for filename in os.listdir(from_dir):
        if filename.endswith('.csv') or filename.endswith('.png'):
            # Construct full file paths
            source_file = os.path.join(from_dir, filename)
            dest_file = os.path.join(dest_dir, filename)

            # Copy the file to the destination directory
            shutil.copy2(source_file, dest_file)
            print(f"Copied: {filename} to {dest_dir}")

            # Delete the original file
            os.remove(source_file)
            print(f"Deleted: {filename} from {from_dir}")

copy_and_delete_csv_png("path to copy from", 
                          "path to copu")

print("all files complete: FIN")



