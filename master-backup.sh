#!/bin/bash

#Local backup location
lbackuploc=/BACKUP

#User backup
backup_user=`cat BACKUP_USER`

#Hostname
hostname=`hostname -s`


#rsync command 
rsync -avz --delete-excluded --exclude-from=BACKUP_FILTER $backup_user $lbackuploc/$hostname | mail -s "Backup DONE for $hostname" root

