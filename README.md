# DLC_HPC
Quick and easy guide to running DLC on Bowdoin's HPC

**Step 1: Downloading necessary software**
  - Download the latest verion of [XQUARTZ](https://www.xquartz.org/) to your MacOS computer (peferably 2.8+)
    - Will use following code in future to check status of GUI (graphic user interface) ``` $ xeyes ```
  - If you are on campus:
    - make sure you are connected to the Bowdoin Wifi (must be Bowdoin, not Bowdoin-Guest or Bowdoin-PSK
  - If you are off campus:
    - Log into the Bowdoin [VPN](https://bowdoin.teamdynamix.com/TDClient/1814/Portal/KB/ArticleDet?ID=99743)


**Step 2: Accessing the Bowdoin HPC through interactive server**
  - Open terminal on MacOS
  - Log in with your Bowdoin credentials with the SSH sever
    - Can either use @dover, @foxcroft, or @slurm

  - Example code:

  ``` terminal
  dhcp-195-230:~ eansmall$ ssh -Y [username]@dover.bowoin.edu
  [username]@dover.bowdoin.edu's password: [enter your password here]
  ```
  
  - Now, we want to access the correct filepath (directory)
    - we can use the ```cd``` feature to quickly move around in terminal's filepaths like the following (once entering a few letters, use the tab key to fill in       the rest instead of writing out your file path each time)
  ``` terminal
  cd /mnt/research/hhorch/[username]
  ```
  - We are now in your HPC-research directory

  - Other helpful tips with terminal

  To move one directory backwards:
  ```cd .```
  
  Two directories backwards:
  ```cd ..```
  
  Instead of writing out the entire file path to your [username] directory, you can access sub directories as follows":
  ```
  [esmall2@dover /mnt/research/hhorch/esmall2]$ cd ./practice_DLC
  [esmall2@dover /mnt/research/hhorch/esmall2/practice_DLC]$
  ```
  
      
