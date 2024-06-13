import deeplabcut

config_path = '/put/your/project/directory/here/config.yaml'

deeplabcut.create_labeled_video(config_path,\
                                ['/put/your/project/directory/to/afolderofvideos'], \
                                videotype='mp4',\
                                shuffle=1,\
                                save_frames=True,\
                                fastmode=True,\
                                filtered=True)
