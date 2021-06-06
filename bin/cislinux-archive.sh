#!/bin/bash
####################################
#
# Backup archival script with
# grandfather-father-son rotation.
#
####################################

# What to backup.
backup_files="/home/k/kylhill/backup/devices /home/k/kylhill/backup/google_drive"

# Where to backup to.
dest="/home/k/kylhill/archive"

# Setup variables for the archive filename.
day=$(date +%A)

# Find which week of the month 1-4 it is.
day_num=$(date +%-d)
if (( $day_num <= 7 )); then
        week_file="archive-week1.tar"
elif (( $day_num > 7 && $day_num <= 14 )); then
        week_file="archive-week2.tar"
elif (( $day_num > 14 && $day_num <= 21 )); then
        week_file="archive-week3.tar"
elif (( $day_num > 21 && $day_num < 32 )); then
        week_file="archive-week4.tar"
fi

# Find if the Month is odd or even.
month_num=$(date +%m)
month=$(expr $month_num % 2)
if [ $month -eq 0 ]; then
        month_file="archive-month2.tar"
else
        month_file="archive-month1.tar"
fi

# Create archive filename.
if [ $day_num == 1 ]; then
    archive_file=$month_file
elif [ $day != "Saturday" ]; then
        archive_file="archive-$day.tar"
else
    archive_file=$week_file
fi

# Backup the files using tar.
tar cf $dest/$archive_file $backup_files

