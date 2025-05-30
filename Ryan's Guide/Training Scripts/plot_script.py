import deeplabcut

config_path = "_____config.yaml"

print("Now creating poses")

deeplabcut.plot_trajectories(
    config_path,
    ['DLC_Output'],
    videotype = 'mp4',
    shuffle=3,
    resolution = 200,
    filtered = False,
    destfolder = 'DLC_Output/'
    )

print("Now creating filtered pose")

deeplabcut.plot_trajectories(
    config_path, 
    ['DLC_Output'], 
    videotype = 'mp4',
    shuffle = 3,
    destfolder = 'DLC_Output/',
    resolution = 200,
    filtered = True
)