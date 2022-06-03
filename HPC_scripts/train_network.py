import deeplabcut

config_path = '/mnt/research/hhorch/esmall2/config.yaml'
deeplabcut.train_network(config_path, shuffle=1, saveiters=5000, maxiters=200000)
