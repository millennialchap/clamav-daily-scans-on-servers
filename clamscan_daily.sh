#!/bin/bash

#written by MillennialChap 2021 - https://millennialchap.com
#Script under the GNU AGPLv3 license.

LOGFILE="/var/log/clamav/autoscan/clamav-$(date +'%Y-%m-%d').log";
HOST="$(hostname --long)";
EMAIL_MSG="Daily ClamAV scan results";
EMAIL_FROM="clamav-daily@your-domain.com";
EMAIL_TO="tec@your-domain.com";
DIRTOSCAN="/var/www /var/qmail";

#Disable freshclam.service
echo "Disable clamav-freshclam.service"
systemctl stop clamav-freshclam.service;

# Update ClamAV database
echo "Looking for ClamAV database updates...";
freshclam --quiet;

TODAY=$(date +%u);

if [ "$TODAY" == "7" ];then
	echo "Starting a full weekend scan.";
	# be nice to others while scanning the entire root
	nice -n5 clamscan -ri / --exclude-dir=/sys/ --exclude-dir=/proc/ &>"${LOGFILE}";
else
	# total size if we use something like /home/*/public_html for scanning
	DIRSIZE=$(du -shc $DIRTOSCAN 2>/dev/null| cut -f1 | tail -1)
	echo -e "Starting a daily scan of ${DIRTOSCAN} directory.\nAmount of data to be scanned is ${DIRSIZE}.";
	nice -n19 clamscan -ri $DIRTOSCAN &>"${LOGFILE}"
fi

# get the value of "Infected lines"
MALWARE=$(tail "${LOGFILE}"|grep Infected|cut -d" " -f3);

# if the value is not equal to zero, send an email with the log file attached
if [ "${MALWARE}" -ne "0" ]; then
	echo "${EMAIL_MSG}"|mail -a "${LOGFILE}" -s "ClamAV: Malware Found" -r "${EMAIL_FROM}" "${EMAIL_TO}";
fi

#Re-enable clamav-freshclam.service
echo "Enable clamav-freshclam.service back again"
systemctl start clamav-freshclam.service;

echo "The script has finished.";
exit 0;
