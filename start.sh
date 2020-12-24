#This is the start-up script for the minecraft server

#!/bin/bash
sudo mkdir -p /home/minecraft
sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/google-minecraft-disk
sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft

sudo apt-get update
sudo apt-get install -y default-jre-headless
cd /home/minecraft
# sudo su # This command is commented out because it will prompt the user to enter credentials before proceeding
# Instead, the sudo command will be used for all the commands below unlike what was written in the tutorial
sudo wget https://launcher.mojang.com/v1/objects/f1a0073671057f01aa843443fef34330281333ce/server.jar
java -Xms1G -Xmx3G -d64 -jar server.jar nogui
nano eula.txt # Go to the bottom of the page and set the value of eula from false to true to agree to the terms and conditions


apt-get install -y screen
screen -S mcs java -Xms1G -Xmx3G -d64 -jar server.jar nogui # Press Ctrl + a then d to detach
# screen -r mcs # reattaches the screen back to the terminal