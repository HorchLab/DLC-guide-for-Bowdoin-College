#!/bin/bash
#SBATCH -J "LABEL VIDS" --mail-type=BEGIN,END,FAIL -N 1 -n 32 --mem=128G

source ~/.bashrc
conda activate dlc3
export DLClight="True";

python -u ./create_labeled_video.py
