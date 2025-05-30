#!/bin/bash
#SBATCH -J "Plot Videos" --mail-type=BEGIN,END,FAIL -N 1 -n 32 --mem=64G 

source ~/.bashrc
conda activate dlc3
export DLClight="True";

python -u ./plot_script.py

# double check sbatch request and change .py name! 









