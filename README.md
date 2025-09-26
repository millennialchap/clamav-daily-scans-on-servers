# ClamAV-Daily-Scans-on-Servers
This Shellscript runs every day in the specified folders.

# Requirements:
sudo apt-get install clamav clamav-freshclam clamav-daemon -y

# Instructions:
- Create a File: nano clamscan_daily.sh
- Create a directory: mkdir /var/log/clamav/autoscan/
- Insert the content of the clamscan_daily.sh file in this repository & change lines 6 to 11 to your needs
- Give the file the needed permissions: chmod 0755 clamscan_daily.sh
- Create a Cronjob: ln clamscan_daily.sh /etc/cron.daily/clamscan_daily
- Test it: sudo bash clamscan_daily.sh
- Done.

# What does this script do?
- Full System scan on every sunday.
- Scanning the directories you specified in line 11
- Disables and re-enables the clamav-freshclam.service as well as checking for updates before scanning
- Sends results per Mail to your inbox daily
- stores the logs in the specified location you choose in line 6 of the script

# Remove older scan reports:
- Create a File: nano clearautoscan.sh
- Insert the content of the clearautoscan.sh file in this repository
- Run it: sudo bash clearautoscan.sh
