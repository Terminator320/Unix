backupSchedule(){
mkdir backup 
echo "======================== Backup Schedule ========================"
read -p "Enter the date (ex. sun, mon, tue, wed, thu, fri, sat): " day
read -p "Enter the time (0-23): " time
read -p "Enter the file name you want to backup: " filename
read -p "Enter the destination folder: " dest

case $day in 
	sun) dayNum=0;;
	mon) dayNum=1;;
	tue) dayNum=2;;
	wed) dayNum=3;;
	thu) dayNum=4;;
	fri) dayNum=5;;
	sat) dayNum=6;;
	*) echo "Invalid day." return;;
esac

mkdir -p "$dest"


#Converting to absolute path
filename="$(readlink -f"$filename")"
dest="$(readlink -f "$dest")"

#use cron command
(crontab -l 2>/dev/null; echo "0 $time * * $dayNum /usr/bin/tar -cf $dest/backup.tar $filename") | crontab -

echo "$time:00 $day backup $filename --> $dest" > lastBackup.txt
echo "Your backup has been scheduled for every $day at $time:00"
echo "File: $filename"
echo "Destination: $dest"
}


lastBackup(){
echo " "
echo "======================== Last Backup Info ========================"
if [ -f lastBackup.txt ]; then
	echo "Last backup: "
	cat lastBackup.txt
else
	echo "No backup has been made yet."
fi
}


BackupManagement(){
while true; do
	echo " "
	echo "===================== Backup Management ====================="
	echo "1) Create a backup schedule"
	echo "2) Display last backup information"
	echo "3) Return to Main Menu"
	echo "4) Exit Program"

	read -p "Select an option [1-4]: " option
	case $option in
		1)
		backupSchedule
		;;
		2)
		lastBackup
		;;
		3)
		echo "Returning to Main Menu"
		MainMenu
		;;
		4)
		echo "Ending program..."
		exit 1
		;;
		*)
		echo "Invalid option"
		;;
esac
done
}

BackupManagement
