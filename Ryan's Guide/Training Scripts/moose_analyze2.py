import deeplabcut

config_path = "_____config.yaml"

deeplabcut.analyze_videos(
    config_path,
    ['/DLC_Output/'], #the path to my videos 
    dynamic = (True, 0.6, 30), #dynamic is for dynamic cropping since the cricket isn't taking up the entire space.
    save_as_csv = True, # weridly defaults to false otherwise
    shuffle = 3, #Tom's shuffle specification
    videotype = 'mp4',  #We're standardizing for mp4 files
    destfolder = 'DLC_Output/'
)

deeplabcut.filterpredictions(
    config_path, 
    ['DLC_Output/'], 
    shuffle = 3, 
    save_as_csv = True,
    destfolder = 'DLC_Output/'
)


# You can choose a checkpoint with the best evaluation results. Change the corresponding index of the checkpoint to the variable snapshotindex in the config.yaml file. By default, the most recent checkpoint (i.e. last) used for analyzing the video. 
# optional arguments include: analyze_videos(config_path, videotype='mkv', shuffle=1, trainingsetindex=0, destfolder=None)
# dest folder is a destination folder for outputs/results. 