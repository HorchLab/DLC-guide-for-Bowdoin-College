import deeplabcut

config_path = '/mnt/research/hhorch/esmall2/practice_DLC/actual_demov2-ELS-2022-06-02/config.yaml'
deeplabcut.analyze_videos(config_path,['/mnt/research/hhorch/esmall2/practice_DLC/videos/']
save_as_csv=True, videotype='avi')


