#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL

source /mnt/local/python-venv/dlc-2.2.1/bin/activate
export DLClight="True";
python '/mnt/research/hhorch/esmall2/Explore-the-space/stim01-trained-ELS-2022-06-09/HPC_Scripts/create_labeled_video.py'
