#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL -p gpu -gres=gpu:rtx3080:1

export PATH=/mnt/local/python-venv/dlc-2.3.9/bin:/mnt/local/cuda-11.8/bin:$PATH
export LD_LIBRARY_PATH=/mnt/local/python-venv/dlc-2.3.9/lib/python3.9/site-packages/nvidia/cudnn/lib:/mnt/local/python-venv/dlc-2.3.9/lib/python3.9/site-packages/tensorrt_libs:/mnt/local/cuda-11.8/lib64:$LD_LIBRARY_PATH
source /mnt/local/python-venv/dlc-2.3.9/bin/activate
export DLClight="True";

python -u ./train_network.py

