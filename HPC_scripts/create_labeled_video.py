import deeplabcut
config_path = '/mnt/research/hhorch/esmall2/Explore-the-space/stim01-trained-ELS-2022-06-09/config.yaml'
deeplabcut.create_labeled_video(config_path, ['/mnt/research/hhorch/esmall2/Honors/Videos of isolates/2022-10-30 17-11-06-ES221003M1GFP- best flight - no light.mp4'], videotype='mp4', shuffle=4, save_frames=True, filtered=True)
