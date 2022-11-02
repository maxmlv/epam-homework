#!/bin/bash

source="source"
dest="backup/$source"
latest_backup="${dest}_latest"
log_file="backup.log"

backup() {
    rsync -ai --delete $source $latest_backup
    rsync -a --delete $source "${dest}_$(date "+%d_%m_%Y_%H_%M")"
}

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

log_backup() {
    dry_run=$( rsync -ai --dry-run --delete $source $latest_backup )
    string=$( echo $dry_run )
    IFS=' ' read -r -a array <<< "$string"
    declare -A changes=$( changes_dict "${array[@]}" )
    for key in ${!changes[@]}; do
        key_date=$(date -r $key "+%d-%m-%Y %H:%M:%S")
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

check_for_updates() {
    dry_run=$( rsync -ai --dry-run --delete $source $latest_backup )
    if [[ $dry_run != "" ]]; then
        log_backup
        backup
    fi
}

check_for_updates
