import deeplabcut

config_path = '/put/your/project/directory/here/config.yaml'
# Per DLC team's recommendation, all changes on iterations should be done on post_cfg.yaml
deeplabcut.train_network(config_path, shuffle=1) # make sure you're selecting the desired shuffle! 


