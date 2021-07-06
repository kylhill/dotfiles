#!/bin/bash
#
# Borgmatic error handler script - https://torsion.org/borgmatic/docs/how-to/monitor-your-backups/
#
EMAIL=kylhill@gmail.com
B_CONFIG=$1
B_REPO=$2
B_ERROR=$3
B_OUTPUT=$4

echo -e "Subject: Error Running borgmatic Backup\n\nError running borgmatic backup: $B_ERROR\r\n\r\nConfig File: $B_CONFIG\r\nRepository: $B_REPO\r\nOutput: $B_OUTPUT\r\n\r\nSee journalctl for more information." | /usr/sbin/sendmail "$EMAIL"
