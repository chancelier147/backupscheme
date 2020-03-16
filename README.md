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
```
#!/bin/bash

#Local backup location
lbackuploc=/BACKUP

#User backup
backup_user=`cat BACKUP_USER`

#Hostname
hostname=`hostname -s`

#rsync command 
rsync -avz --delete-excluded --exclude-from=BACKUP_FILTER $backup_user $lbackuploc/$hostname | mail -s "Backup DONE for $hostname" root
```

In our script we also use the mailutils program to send backup information to the root user.

**2. BACKUP\_USER**  **rights and permissions 600** ** (-rw------- 1 user  user)**

Here is its content, here you replace **user** by your username :
```
/home/user/
```
This configuration file will contain the list of files and directories that will be saved in the /BACKUP directory.

**3. BACKUP\_FILTER**  **rights and permissions 600** ** (-rw------- 1 user  user)**

This file will contain the list of files or regular expression patterns that you do not want to save.

Here are its contents :
```
*.ogg
*.iso
```
**4. compress-backup.sh**  **rights and permissions 700** ** (-rwx------ 1 root root)**

This script allows to compress files saved in bzip2 format.The compressed files are named using the pattern &quot;archive\_&quot;, the hostname, today&#39;s date, and end with .tar.bz2 and saved in /BACKUP. The old archive files will be deleted with the &quot;find&quot; command if they are older than 180 days.

Here are its contents :
```
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
```

**AUTOMATING BACKUPS WITH CRON**

Here we set up automatic backup and compression every day at 3 a.m. and 5 a.m. respectively.
```
0 3 * * * /opt/scripts/master-backup.sh
0 5 * * * /opt/scripts/compress-backup.sh
```
