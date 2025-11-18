backupSchedule(){
echo "======================== Backup Schedule ========================"
read -p "Enter the date (ex. Monday, Tuesday): " date
read -p "Enter the time (ex. 04:00 or 15:00): " time
read -p "Enter the file name you want to backup: " filename
read -p "Enter the destination folder: " dest

echo "$time $date backup $filename --> $dest" > lastBackup.txt
echo "Your backup has been scheduled for every $date at $time"
echo "File: $filename"
echo "Destination: $dest"
}


lastBackup(){
echo " "
echo "======================== Last Backup Info ========================"
if [-f lastBackup.txt]; then
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
