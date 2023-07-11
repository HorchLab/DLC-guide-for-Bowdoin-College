import os

# find all csv files's name in the current directory (recursively) 
# and print them

def find_csv_files(path):
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(".csv"):
                print(os.path.join(root, file))

find_csv_files(".")