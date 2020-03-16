**BACKUP SCHEME**

LOCAL BACKUP SCHEME USING RSYNC, COMPRESS AND SCHEDULE USING CRONTAB



For our backup project, we create two directories, a directory named &quot;BACKUP&quot; at the root of our system &quot;/&quot; and a directory named &quot;scripts&quot; in the /opt/ directory.

The &quot;/BACKUP&quot; directory will contain the backed up files and their archives while the /opt/scripts/ directory will contain our backup scripts and configuration files.



**scripts and configuration files**

/opt/scripts/

├── BACKUP\_FILTER

├── BACKUP\_USER

├── compress-backup.sh

└── master-backup.sh



We have two scripts and two configuration files

**1. master-backup.sh**  **rights and permissions 700** ** (-rwx------ 1 root root)  **

Here are its contents :

**#!/bin/bash**

**#Local backup location**

**lbackuploc=/BACKUP**

**#User backup**

**backup\_user=`cat BACKUP_USER`**

**#Hostname**

**hostname=`hostname -s`**

**#rsync command**

**rsync -avz --delete-excluded --exclude-from=BACKUP\_FILTER $backup\_user $lbackuploc/$hostname | mail -s &quot;Backup DONE for $hostname&quot; root**

In our script we also use the mailutils program to send backup information to the root user.

**2. BACKUP\_USER**

Here is its content, here you replace **user** by your username :

**/home/user/**

This configuration file will contain the list of files and directories that will be saved in the /BACKUP directory.

**3. BACKUP\_FILTER**

This file will contain the list of files or regular expression patterns that you do not want to save.

Here are its contents :

**\*.ogg**

**\*.iso**

**4. compress-backup.sh**

This script allows to compress files saved in bzip2 format.The compressed files are named using the pattern &quot;archive\_&quot;, the hostname, today&#39;s date, and end with .tar.bz2 and saved in /BACKUP. The old archive files will be deleted with the &quot;find&quot; command if they are older than 180 days.

Here are its contents :

**#!/bin/sh**

**#Hostname**

**#hostname=`hostname -s`**

**#Date**

**date=`date +%Y.%m.%d`**

**# compress latest backup to archive**

**cd /BACKUP/;tar jcf archive\_`hostname -s`\_$date.tar.bz2 `hostname -s`/; chown root:root archive\_\***

**# delete old archives after 180 days**

**find /BACKUP/archive\_\* -type f -mtime +180 -exec rm  {} \;**

**# time stamp when the backup scripts completes**

**logger &quot;BACKUP\_Compress Completed for `hostname -s`&quot;**



**AUTOMATING BACKUPS WITH CRON**

Here we configure the backup automatically every day at 3am and the compression at 5am.

0 3 \* \* \* /opt/scripts/master-backup.sh

0 5 \* \* \* /opt/scripts/compress-backup.sh
