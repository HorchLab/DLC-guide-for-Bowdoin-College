#!/bin/bash
#SBATCH -J "Analy_Vid" --mail-type=BEGIN,END,FAIL -p gpu --gres=gpu:a100:1 --mem=128G 

source ~/.bashrc
conda activate dlc3
export DLClight="True";

python -u ./moose_analyze2.py

# double check sbatch request and change .py name! 
