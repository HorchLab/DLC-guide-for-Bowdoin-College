import deeplabcut

config_path = "_____.yaml"

deeplabcut.create_labeled_video(
    config_path,
    ['DLC_Output'],
    videotype = 'mp4',
    shuffle = 3,
    fastmode = False,
    save_frames = True, 
    filtered = True,
    destfolder = 'DLC_Output',
    draw_skeleton = True
)
