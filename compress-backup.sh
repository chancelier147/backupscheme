#!/bin/sh

#Hostname
#hostname=`hostname -s`

#Date
date=`date +%Y.%m.%d`

# compress latest backup to archive
cd /BACKUP/;tar jcf archive_`hostname -s`_$date.tar.bz2 `hostname -s`/; chown root:root archive_*

# delete old archives after 180 days
find /BACKUP/archive_* -type f -mtime +180 -exec rm  {} \;

# time stamp when the backup scripts completes
logger "BACKUP_Compress Completed for `hostname -s`"
