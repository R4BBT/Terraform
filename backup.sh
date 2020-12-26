#!/bin/bash
screen -r mcs -X stuff '/save-all\n/save-off\n'
/usr/bin/gsutil cp -R ${BASH_SOURCE%/*}/world gs://[mcbackup122420]/$(date "+%Y%m%d-%H%M%S")-world
screen -r mcs -X stuff '/save-on\n'

# run 
# sudo chmod 755 /home/minecraft/backup.sh