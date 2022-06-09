#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL

source /mnt/local/python-venv/dlc-2.2/bin/activate
export DLClight="True"; 
python 'full/filepath/to/your/video/videos'


