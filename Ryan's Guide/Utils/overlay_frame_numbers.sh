#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL -p gpu --gres=gpu:rtx3080:1 --mem=128G 

source ~/.bashrc 

python -u ./overlay_frame_numbers.py


