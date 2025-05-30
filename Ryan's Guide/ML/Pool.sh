#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL -p gpu --gres=gpu:rtx3080:1 --mem=128G 

source ~/.bashrc 

python -u ./Pool_test.py


