# Task 3

## Requirements

#### Create a data backup script that takes the following data as parameters:

1. Path to the syncing  directory.
2. The path to the directory where the copies of the files will be stored.

>In case of adding new or deleting old files, the script must add a corresponding entry to the log file
indicating the time, type of operation and file name. [The command to run the script must be added to
crontab with a run frequency of one minute]

---

## Solution

Backup squript pass three arguments:
- Path to the source directory
- Path to the backup directory that represents the same name as source directory
- Path to the log file

``` bash
source="$1"
dest="$2/$(basename $source)"
latest_backup="${dest}_latest"
log_file="$3"
```
---

Script begins with __check_for_updates()__ function checks if dry-run returns output.
If it is that means changes in source being made and it starts the backup and log process.

``` bash
check_for_updates() {
    dry_run=$( rsync -ai --dry-run --delete $source $latest_backup )
    if [[ $dry_run != "" ]]; then
        log_backup
        backup
    fi
}
```

---
__backup()__ function is pretty stright forward, but it creates two replicas to track latest backup and create second copy of exact changes at that point.

``` bash
backup() {
    rsync -ai --delete $source $latest_backup
    rsync -a --delete $source "${dest}_$(date "+%d_%m_%Y_%H_%M")"
}
```
---
__log_backup()__ function is more complicated, and it gets the dry-run of backup proccess. It would be look like this:

> *file.txt >f+++++++ folder cd+++++++*

Function breakes down to array this string and call the __changes_dict()__ to convert it to dictionary:

> *{ "file.txt" = ">f+++++++", "folder" = "cd+++++++" }*

``` bash
changes_dict() {
    raw_array=("$@")
    len=${#raw_array[@]}
    echo "("
    for i in $(seq 1 2 $len); do
        key=${raw_array[$i]}
        value=${raw_array[(($i-1))]}
        echo "[$key]='$value'"
    done
    echo ")"
}
```

After that loop goes through the dictionary and write the logs according to changes being made.

``` bash
log_backup() {
    dry_run=$( rsync -ai --dry-run --delete $source $latest_backup )
    string=$( echo $dry_run )
    IFS=' ' read -r -a array <<< "$string"
    declare -A changes=$( changes_dict "${array[@]}" )
    for key in ${!changes[@]}; do 
        if [[ -z $key ]]; then
            key_date=$(date -r $key "+%d-%m-%Y %H:%M:%S")
        else
            key_date=$(date "+%d-%m-%Y %H:%M:%S")
        fi
        case ${changes[$key]} in
            "cd+++++++++")
                echo "[$key_date] <CREATED> directory $key" >> $log_file
                ;;
            ">f+++++++++")
                echo "[$key_date] <CREATED> file $key" >> $log_file
                ;;
            ">f.st......")
                echo "[$key_date] <UPDATED> $key" >> $log_file
                ;;
            "*deleting")
                echo "[$(date "+%d-%m-%Y %H:%M:%S")] <DELETED> $key" >> $log_file
                ;;
        esac
    done
}
```

### Example of log file
```
[06-11-2022 16:23:08] <CREATED> directory source/folder1/
[06-11-2022 16:23:08] <CREATED> file source/folder1/myfile.txt
[06-11-2022 16:23:08] <CREATED> directory source/
[06-11-2022 16:23:43] <UPDATED> source/folder1/myfile.txt
[06-11-2022 16:33:01] <UPDATED> source/folder1/myfile.txt
[06-11-2022 16:35:01] <DELETED> source/folder1/myfile.txt
[06-11-2022 17:03:01] <CREATED> file source/folder1/crontest_file.txt
[06-11-2022 17:05:02] <UPDATED> source/folder1/crontest_file.txt
```
---
## CRON

Last requirement for the task was to add backup script to __crontab__ with frequency of 1 minute.

```
*/1 * * * * bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log
```

### CRON syslogs

```
Nov  6 17:49:01 maxmlv CRON[4965]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:50:01 maxmlv CRON[4973]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:51:01 maxmlv CRON[4981]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:52:01 maxmlv CRON[4989]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:53:01 maxmlv CRON[4997]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:54:01 maxmlv CRON[5010]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:55:01 maxmlv CRON[5023]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:56:01 maxmlv CRON[5031]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:57:01 maxmlv CRON[5044]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:58:01 maxmlv CRON[5052]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
Nov  6 17:59:01 maxmlv CRON[5066]: (maxmlv) CMD (bash ~/epam/bash/task3/backup.sh ~/epam/bash/task3/source ~/epam/bash/task3/backup ~/epam/bash/task3/backup.log)
```


