# Steps to use DLC on Bowdoin's HPC

This guide was written to help with the basics of getting DLC up and running. For the most detailed user guide, DLC offers a very handy one located at: https://github.com/DeepLabCut/DeepLabCut/blob/main/docs/standardDeepLabCut_UserGuide.md

I suggest reading through this entire Markdown and if any specific questions remain, take a look at DLC's user guide.

## Step 1: Downloading necessary software
1.1: Download the latest verion of [XQUARTZ](https://www.xquartz.org/) to your MacOS computer (peferably 2.8+)
- Use following code to check if it works `$ xeyes`, there should be an window with two eyes 👀. 
- If you're using homebrew on your computer, run `brew install --casks xquartz` would be an easy way out. 

1.2.1: If you are on campus:
- Make sure you are connected to the Bowdoin network (must be **Bowdoin** or **eduroam**, not Bowdoin-Guest or Bowdoin-PSK)

1.2.2: If you are off campus:
- Log into the Bowdoin [VPN](https://bowdoin.teamdynamix.com/TDClient/1814/Portal/KB/ArticleDet?ID=99743)

## Step 2: Accessing the Bowdoin HPC through interactive server
  2.1: Open terminal on MacOS. 
  
  2.2: Log in with your Bowdoin credentials with the SSH sever
  - Can either use @dover, @foxcroft, or @slurm

  -  Example code:
  ```terminal
  dhcp-195-230:~ eansmall$ ssh -Y [username]@dover.bowoin.edu
  [username]@dover.bowdoin.edu's password: [enter your password here]
  ```
  > `-Y` here is needed to estabilish a X11 connection (which enables display)! 
  > replace `[username]` with your username!
  > If you're on Bowdoin's network **and** using your Bowdoin laptop or logged into your account on a Bowdoin computer, you can simpify this to `ssh -Y dover`. 
  - To make sure the graphic user interface (GUI), we need to submit following line of code:
  ```
  [chan@dover ~]$ xeyes
  ```
  - This code should result in a pair of eyes pop-up that tracks your mouse. You can exit that screen, but now your GUI should work
  
  2.3: Now, we want to access the correct filepath (directory)
      - we can use the `cd` feature to quickly move around in terminal's filepaths like the following (once entering a few letters, use the tab key to fill in the rest instead of writing out your file path each time)
  ```
  [chan@dover ~]$ cd /mnt/research/hhorch/[username]
  ```
  - We are now in your HPC-research directory

  Other helpful tips with terminal
  | Command | Description |
  | --- | --- |
  | `cd .` | View current directory |
  | `cd ..` | Move one directory backwards |
  | `cd ./practice_DLC` | Access subdirectories of your current directory |
  | `ls` | View the contents of each directory by name |
  | `ls -l` | View contents with more detail |
  | `mkdir [name of directory]` | Make a new directory manually |
  | `cp [filepath of file] [filepath of destination]` | Copy materials manually |
      

## Step 3: creating DeepLabCut (DLC) environments and running ipython to use DLC on HPC interactive servers

3.1: We first need to create a DLC environment: this is activating a local python environment with DLC version 2.2

``` source /mnt/local/python-venv/dlc-2.2/bin/activate ```

3.2: Next, we need to open a virtual python environment:

``` ipython ```

3.3: Python is now open and you should be prompted with the following:

```python
In [1]: 
```
- Here, you can import deeplabcut with the following code and click return:

```python
In [1]: import deeplabcut
"DLC loaded in light mode; you cannot use any GUI (labeling, relabeling and standalone GUI)"
```

## Step 4: creating DeepLabCut (DLC) project, extract frames, label frames, and train your network

### 4.1: Create a new project
Now, lets start using DLC to create a new project with the following code:

```python
In [2]: deeplabcut.create_new_project('name of project', 'your name', ['complete file path to video'], (optional) working_directory='file path to where you want project saved')
```
- additional parameter includes:
    - `copy_videos=True/False` which will create a reference to a video in the video directory

### 4.2: Save the configuration profile
Great, your new project is created, but lets save the filepath to the configuration file (config.yaml) as a variable. 

> This part is optional, but would save you a lot of time in the future and codes below will assume you have done this step. 

```python
In [3]: config_path = '/mnt/research/hhorch/[username]/[working directory]' 
```

### 4.3: Extract frames from the video. 
We can now extract frames:
    - This may take a few moments, but you should see the frames being counted
    - You will primarily use 'automatic' and 'kmeans' as the parameters, but these are default, so you don't always have to fill them in
    - For some reasons, this line is sensitive to case and/or the difference between double and single quote. 

```python
In [4]: deeplabcut.extract_frames(config_path, 'automatic/manual', 'uniform/kmeans')
"Do you want to extract (perhaps additional) frames for [file path]? yes/no" yes 
...
"Kmeans clustering (this may take a while)"
...
"Frames were successfully extracted, for the videos listed in the config.yaml file."
"You can now label the frames using the function 'label_frames' (Note, you should label frames extracted from diverse videos (and many videos; we do not recommend training on single videos!))."
```

A real example would look like the following: 
```python
deeplabcut.extract_frames(config, mode='automatic')
"Config file read successfully."
"Do you want to extract (perhaps additional) frames for video: /mnt/research/hhorch/esmall2/Explore-the-space/stim01-trained-ELS-2022-06-09/videos/2020-10-27 09-38-34 201026UM1 stim01.mkv ? yes/no" [type your response here] yes

"Kmeans-quantization based extracting of frames from 0.0  seconds to 178.23  seconds."
"Extracting and downsampling... 10694  frames from the video."
"10694it [01:44, 102.62it/s]"
```

If you are extracting frames for a second time, it will prompt you with the following

```python
"The directory already contains some frames. Do you want to add to it?(yes/no):" yes
```
- additional paramerters include: 
  - `crop=True/False` which can crop the video if True
  - `userFeedback=True/False` which will ask the user to process a specific video before doing so. 

### 4.4: Label frames

4.3 gives us the frames, now we can label them:

```python
In [5]: deeplabcut.label_frames(path_config)
```

You can now label each bodypart for each frame before training the network
![The DLC GUI should now pop-up](./HPC_scripts/labeling.png)

> NOTE: I was using a marker size of 12 for each training before this. I changed it to 5 to be more precise, whihc I think will ultimately be more accurate. - Ean
> The marker size doesn't matter for the actual training, because the labels are just one xy coordinate for each body part, but a smaller marker size will allow for more precise labeling. - Tom

### 4.5: Check Labels

Before training the network, let's make sure our labels were correctly placed:

```python
In [6]: deeplabcut.check_labels(path_config)
"Creating images with labels by [your name]."
"100%|████████████████████████████████████████████████████████████████████████████| 19/19 [00:13<00:00,  1.41it/s]"
"If all the labels are ok, then use the function 'create_training_dataset' to create the training dataset!"
```

### 4.6: Create training data set

Finally, let's create a training dataset

```python
In [7]: deeplabcut.create_training_dataset(path_config)
"The training dataset is successfully created. Use the function 'train_network' to start training. Happy training!"
```

Great! Now we can start training the network.
  
## Step 5: Training the network using Bowdoin's GPU computers (ie ~~Moosehead~~ slrum)
All of this is located [here](https://hpc.bowdoin.edu/hpcwiki/index.php?title=Linuxhelp:Deeplabcut) as well

### 5.1: Log into HPC
Now we need to log into Bowdoin's @slurm or @moosehead GPU servers with the following. Open a new terminal window and login within the following:
```
ssh -Y [username]@slurm.bowdoin.edu
[username]@slurm's password: [enter password]
```

- Unlike @dover and @foxcroft, we have to pass scripts (.sh files) to the HPC so that it can perfom high performance computing using the GPU's (which allow for larger capacities of data)
- You can find all of the scipts and python files in the [HPC_scripts](https://github.com/esmall2023/DLC_HPC/tree/main/HPC_scripts) folder in this repository.

### 5.2: Submit the training job to the cluster
You then need to submit this "job" to the cluster with the following code:

```
sbatch -p gpu --gres=gpu:rtx3080:1 --mem=32G training_script.sh
```

> **TODO:** Add some information about sbatch and .out files here. 

## Step 6: Evaluating the network, analyzing novel videos, and filtering predictions
Once we have trained our network as in step 6, we want to evaluate the network to see how well it was trained. 
~~There are parameters called Train error and Test Error. For the sake of our experiment and from my research (which was very hard to find), if the train and test error are close to eachother (in pixels) and they are both close to, or below 4 px, then the training is sufficient.~~

> Train error and Test error means in-sample error and out-of-sample error. If the train error is very low and the test error is very high, then the model is overfitting. If the train error is high and the test error is low, then the model is underfitting. A rule of thumb is to have the train error and test error be close to each other and low. - Tom

You can also create labeled videos to determine whether DLC was able to accurately locate each body part throughout the video.

### 6.1: Evaluating the network

We do so the same way as training the network with the script file. Make sure you are in the right directory where your HPC_scripts are like this: `/mnt/research/hhorch/esmall2/Explore-the-space/stim01-trained-ELS-2022-06-09/HPC_Scripts`

```
sbatch -p gpu --gres=gpu:rtx3080:1 --mem=32G evaluate_script.sh
```

- For `Shuffles[1]` in evaluate_network.py, you will want to change this for each shuffle that you did. For example, if you set Shuffles=3 when training the network, then submit this script when Shuffles=[1], Shuffles=[2], and Shuffles=[3]. 

The evaluation results might look something like this: you can find them by going to ./evaluation-results/iteration-7/ and it is the .csv file at the top
![Might look something like this](./HPC_scripts/evaluation.png)

### 6.2: Analyze Novel Videos
Once we evaluate the network, we will want to analyse new video to determine how well the network was actually trained:

```python
In [1]: deeplabcut.analyze_videos(config, ['full path of video'], videotype='mkv or your videotype', save_as_csv=True)
```

### 6.3: Filter predictions.

In order to make a graph, we need to filter the CSV values using the following code:

```python
In [2]: deeplabcut.filterpredictions(config, ['full path of video'], videotype='mkv or your videotype', shuffle=1)
```

### 6.4: Create Labelled Videos

We can also create a labeled video to see whether the labels for the body parts were marked correctly using one of the HPC scripts:

```
sbatch -p gpu --gres=gpu:rtx3080:1 --mem=32G create_labeled_script.sh
```

## Step 7: Re-training the network if it wasn't trained well enough

7.1: In order to do so, we will typically want to add new/more videos to our training dataset with the following code:

```
deeplabcut.add_new_videos(config, ['full path to each specific video'])
```

#### NOTE: I tried just using the path to the file containing all of the videos, but it didn't work so I had to add each new video individually - Tom

### 7.2: Once you've added the new videos, you can repeat steps 4.3 and beyond.
  


