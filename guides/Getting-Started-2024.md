# Using DeepLabCut on Bowdoin's Environment

This guide was based on the older version of DLC guide from Ean Small '23, written to help with the basics of getting DLC up and running. For the most detailed user guide, [DLC offers a very handy one.](https://github.com/DeepLabCut/DeepLabCut/blob/main/docs/standardDeepLabCut_UserGuide.md) 

> Note that as of July-August 2024, DeepLabCut is going though a transition to DLC 3.0 with new features and PyTorch as the backend. This guide is based on DeepLabCut 3.0. 

## Before DeepLabCutting

### Right tools for the right job
There's multiple ways to use DeepLabCut, technically all of the processes can be done on your laptop/local machine. However, it will take a painstaking time to process and train the model on a chromebook or the chromebook equivalent of our M2 MacBook Pros. However, for some less computational intensive tasks, local machines is far more than enough and don't have the overhead of submitting and waiting for outputs of the HPC. Here's a overview of what is an HPC job and what is more of a local job: 

| Local Job (Computationally Light) | HPC's GPU Job (Needs a GPU) | HPC's CPU Job (CPU intensive) |
|------------------------------------|-----------------------------|-------------------------------|
| Create a project | Training a model | Create Labeled Data |
| Labelling with GUI | Evaluating model | Extracting outlier frames |
| Create training datasets | Analyzing videos | Plotting Trajectories |
|  |  | Filtering Predictions | 

- Local Jobs
  - Takes seconds to minutes to run, and
  - Needs a lot of interactions with DLC's GUI, or
  - it's not worth is to submit a job to the HPC for such a small task.
- HPC's GPU Jobs
  - Interacts with the GPU for machine learning, and
  - takes a long time to run. 
  - **Unless you know what you're doing, don't run this on your local machine.**
- HPC's CPU Jobs
  - Interacts with the CPU for processing, and
  - Probably needs a lot of memory.
  - t**Unless you know what you're doing, don't run this on your local machine.**

### Setting up the environment on your computer

For DeepLabCut on your local machine, you can follow the official guide for an installation. A conda environment might scary at first espeically if you're not familiar with it, but it's a great way to manage your dependencies and not mess up your system's python.

- [ ] Install miniconda3 on your computer. (If you have homebrew, run `brew install miniconda3`)
- [ ] Download the config file from DLC's website: [Link here](https://github.com/DeepLabCut/DeepLabCut/blob/main/conda-environments/DEEPLABCUT.yaml#:~:text=Raw%20file%20content-,Download,-%E2%8C%98)
- [ ] Navigate to where you downloaded the file in terminal, and run `conda env create -f DEEPLABCUT_M1.yaml`. This will create a new conda environment with all the dependencies you need for DLC.

Whenever you want to interact with DeepLabCut on your machine: 
1. Run `conda activate DEEPLABCUT` to activate the environment. (If you named it differently, replace `DEEPLABCUT` with the name you gave it.)
2. Run `python -m deeplabcut` to start the GUI.
3. Alternatively, run `ipython` for a interactive python environment, then run `import deeplabcut`. A constantly changing software like DeepLabCut might have some features that are not in the GUI yet, so it's good to know how to interact with it in the terminal.

### Setting up the environment on the HPC

Coincidentally Bowdoin HPC is also under going a transition to a new system, so the following steps might be outdated. However, the general idea is the same. I took sometimes to get conda and dlc 3.0.0 to work on the HPC.

1. Open terminal on macOS. (If you're on a window laptop, try using [WSL](https://docs.microsoft.com/en-us/windows/wsl/install) or [PuTTY](https://www.putty.org/) for a shell)

2. Log in with your Bowdoin credentials with the SSH sever
You can either use @dover, @foxcroft, @slurm, or @moosehead
Example code:
```
dhcp-195-230:~ eansmall$ ssh -Y [username]@dover.bowoin.edu
... (There will be some text here)
[username]@dover.bowdoin.edu's password: [enter your password here]
```
> replace `[username]` with your username!

3. Learn to navigate through terminal. Here's a useful reference courtesy of [Professor Sean Barker](https://tildesites.bowdoin.edu/~sbarker/unix/)