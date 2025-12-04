
#main menu
MainMenu(){
while true; do
  echo -e "\e[37m=======================================  Main Menu  =======================================\e[0m"
  echo " "
  echo -e "\e[1;36m1) System Status\e[0m"
  echo -e "\e[1;35m2) Backup Management\e[0m"
  echo -e "\e[1;33m3) Network Management\e[0m"
  echo -e "\e[1;34m4) Service Management\e[0m"
  echo -e "\e[38;5;51m5) User Management\e[0m"
  echo -e "\e[38;5;208m6) File Management\e[0m"
  echo -e "\e[1;31m7) Exit Program\e[0m"

  read -p "Select an option [1-7]: " opt

  case $opt in
	1)
	  SystemStatus
	;;
	2)
	  BackupManagement
	;;
	3)
	  NetworkManagement
	;;
	4)
	  Server_Management
	;;
	5)
	  UserManagement
	;;
	6)
	  FileManagement
	;;
	7)
	  echo -e "\e[1;31mEnding program...................\e[0m"
	  exit 1
	;;
	*)
	  echo -e "\e[1;31mInvalid Option\e[0m"
	;;
  esac
done
}



#--------------------------------System Status----------------------------------------
getMemoryInfo(){
total=$(free -h | awk 'NR==2 {print $2}')
used=$(free -h | awk 'NR==2 {print $3}')
available=$(free -h | awk 'NR==2 {print $7}')
echo "The total memory is $total and $used is used. There is $available of memory available."
}
temperatureCheck(){
TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
TEMPC=$((TEMP / 1000))

if [ $TEMPC -gt 70 ]
then
echo "The temperature of the CPU reached 70C or more. $TEMPC"
else
echo "The temperature is normal  $TEMPC"
fi
}

listActive(){
sudo apt update
sudo apt install htop

htop

}

killProcess(){
ps -aux
read -p "Which process do you want to kill. Use the PID to kill it." killID
if sudo kill -0 $killID >/dev/null; then
echo "Killed the procress"
else
echo "Could not kill it for some reason."
fi

}
SystemStatus(){
while true;do
  echo " "
  echo "=======================================  System Management ======================================="
  echo "1) Display detailed information about memory usage."
  echo "2) Check the CPU Temperature"
  echo "3) List all active program"
  echo "4) Let the user stop or end a specific process."
  echo "5) Back to main menu"
  echo "6) Exit the program"
  read -p "Select an option [1-4]: " option

  case $option in
         1) 
         getMemoryInfo
         ;;
         2)
         temperatureCheck
         ;;
         3)
          listActive
         ;;
         4)
          killProcess
         ;;
         5)
          echo "Returning to Main Menu"
          MainMenu
         ;;
         6)
          echo "Exiting the program..."
          exit 1
          ;;
        *)
         echo "Invalid option"
        ;;
  esac
done
}


#--------------------------------Backup Management-----------------------------------
backupSchedule(){
mkdir -p backup
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
filename="$(readlink -f "$filename")"
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


#-------------------------------Network Management------------------------------------

displayInterfaces(){
echo " "
	echo "==================== Network Interfaces and IPs ===================="

	for interface in $(ls /sys/class/net/); do
		ip_address=$(ip -o -4 addr show $interface | awk '{print $4}')
		if [ -n "$ip_address" ]; then
			echo "Interface: $interface, IP Address: $ip_address"
		else
			echo "Interface: $interface, No IP Address assigned"
		fi
	done
}

toggleInterfaces(){
	echo " "
	echo "==================== Enable and Disable Interface ===================="
	read -p "Enter interface name: " interface
	read -p "Would you like to enable (1) or disable (2) this interface?: " input

	case $input in
		1)
		sudo ip link set $interface up
		echo "$interface has been enabled";;
		2)
		sudo ip link set $interface down
		echo "$interface has been disabled";;
		*)
		echo "Invalid option";;
	esac
}

setIPAddress(){
	echo " "
	echo "==================== Assign IP Address ====================="

	read -p "Enter interface name: " interface
	read -p "Enter IP Address: " ip_num

	sudo ip addr add $ip_num dev $interface
	echo "IP Adress $ip_num has been assigned to $interface"
}

listWifi(){
	echo " "
	echo "===================== Available WiFi Networks ===================="

	sudo nmcli dev wifi
	read -p "Enter Wifi name you want to connect to: " wifi
	read -p "Enter password: " pwd

	sudo nmcli dev wifi connect "$wifi" password "$pwd"
	echo "Connecting to $wifi..."
}


NetworkManagement(){
	while true; do
		echo " "
		echo "==================== Network Management ===================="
		echo "1) Display all network interfaces and IP addresses"
		echo "2) Enable or Disable a network interface"
		echo "3) Assign IP address to an interface"
		echo "4) Display Wifi networks and connect"
		echo "5) Return to Main Menu"
		echo "6) Exit program"
		echo " "

		read -p "Select an option (1-6): " option

		case $option in 
			1) displayInterfaces;;
			2) toggleInterfaces;;
			3) setIPAddress;;
			4) listWifi;;
			5) MainMenu;;
			6) 
			echo "Ending program..."
			exit 1;;
			*)
			echo "Invalid option";;
		esac
done
}


#------------------------------Service Management--------------------------------------
#checking function
confirmation(){
  #checking if its active or not
  check=$(systemctl status $1 | awk 'NR==3 {print $2}')

  #if its active user has started it
  if [ "$check" == "active" ];then
     echo -e "\e[1;32mYou have started $1\e[0m"
  #if its not active then user hasn't stop it
  else
    echo -e "\e[1;32mYou have stopped $1\e[0m"
  fi
}

#display all  running service
display(){
#only list the service that's states is running then it only display lines that>
  echo " "
  echo -e "\e[1;36m=======================================  All Running Services  =======================================\e[0m"
  systemctl list-units --type=service --state=running | grep '.service'
}

#start stop function
startStop(){
  echo " "
  echo -e "\e[1;33m=======================================  Start Or Stop Services =======================================\e[0m"
  #asking for stop or start
  read -p "Would you like to start or stop a service (start or stop): " startOrStop

  if [ "$startOrStop" != "start" ] && [ "$startOrStop" != "stop" ]; then
    echo -e "\e[1;31mInvalid option. Please enter 'start' or 'stop'.\e[0m"
    return 1
  fi

  #asking for which  service
  read -p "Please enter a service you'd like to $startOrStop: " service

  # Check if service exists
  if ! systemctl show "$service" &>/dev/null; then
	echo -e "\e[1;31mService '$service' does not exist.\e[0m"
	return 1
  fi

  if [ "$startOrStop" == "start" ]; then
     while true; do
  	#double check if user want to start the service
  	read -p "Are you sure you want to start: $service? (y/n):  " answer

	if [ "$answer" == "y" ]; then
	   #starting service
           sudo systemctl start "$service"
           confirmation "$service"
   	elif [ "$answer" == "n" ]; then
           echo -e "\e[1;31m$server will not start.\e[0m"
   	else
	   echo -e "\e[1;31mInvalid Option\e[0m"
   	fi
       break
     done
  elif [ "$startOrStop" == "stop" ]; then
    while true; do
  	#double check if user wants to stop the service
  	read -p "Are you sure you want to stop: $service ? (y/n): " ans

	if [ "$ans" == "y" ]; then
	   #stopping service
           sudo systemctl stop "$service"
	   confirmation "$service"
	elif [ "$ans" == "n" ]; then
	    echo -e "\e[1;31m$service will not be stop.\e[0m"
  	else
	    echo -e "\e[1;31mInvalid option\e[0m"
   	fi
       break
     done
  else
    echo -e "\e[1;31mInvalid. Please re-enter: (start or stop) \e[0m"
 fi
}


#Service management menu
Server_Management(){
while true;do
  echo " "
  echo -e "\e[1;34m=======================================  Service Management =======================================\e[0m"
  echo -e "\e[1;36m 1) View all Running Services.\e[0m"
  echo -e "\e[1;33m 2) Start and Stop Services.\e[0m"
  echo -e "\e[1;37m 3) Return to Main Menu.\e[0m"
  echo -e "\e[1;31m 4) Exit the Program.\e[0m"

  read -p "Select an option [1-4]: " option

  case $option in
         1)
          display
         ;;
         2)
          startStop
         ;;
	 3)
	  echo "Returning to Main Menu"
	  MainMenu
	 ;;
         4)
          echo -e "\e[1;31mExiting the program...\e[0m"
          exit 1
          ;;
        *)
         echo -e "\e[1;31mInvalid option\e[0m"
        ;;
  esac
done
}

#--------------------------------------User Management--------------------------------------
#create new user
createUser(){
  echo " "
  echo -e "\e[1;92m============================  Creating Users  ============================\e[0m"
  read -p "Enter a username: " username

  #check if the user exists
  if id "$username" &>/dev/null; then
     echo -e "\e[1;31mUser already exists.\e[0m"
  else
    sudo useradd "$username"
    sudo passwd "$username"
    echo -e "\e[1;32mA new user ($username) has been created.\e[0m"
  fi
}


#root permission
rootPerm(){
echo " "
echo -e "\e[1;91m============================  Grant Root Premission  ============================\e[0m"
#showing the user all the users sp they can pick
  echo "Here are a list of all users: "
  formatOut=$(cat /etc/passwd | grep home | cut -d: -f1 | pr -t -a -4)
  echo "$formatOut"

  read -p "PLease enter a user you'd want to give root permission: " user
  #check if the user exists or not
  if id "$user" &>/dev/null;then
    while true; do
	read -p "Are you sure you want to give $user sudo premisson? (y/n) " ans
	if [ "$ans" == "y" ]; then
    	   #adding root perms to the user
    	   sudo usermod -aG sudo "$user"
	   echo -e "\e[1;32mThe user '$user' now has sudo permission.\e[0m"
	 elif [ "$ans" == "n" ]; then
	   echo -e "\e[1;32mThe user '$user' will not be given sudo permission.\e[0m"
	else
	  echo -e "\e[1;31mInvalid option.\e[0m"
	fi
	return
    done
  else
    echo -e "\e[1;31mThe user $user does not exists\e[0m"
fi
}


#Deleting a user
deleteUser() {
  echo " "
  echo -e "\e[1;94m============================  Deleting Users  ============================\e[0m"
  #showing the user all the users so they can pick
  echo "Here are a list of all users: "
  formatOut=$(cat /etc/passwd | grep home | cut -d: -f1 | pr -t -a -4)
  echo "$formatOut"


  read -p "Please enter a user you'd want to delete: " user
  #check if the user exists or not
  if id "$user" &>/dev/null; then
    	#double checking if they want to delete the user
    	read -p "Are you sure you want to delete the user: $user ?   (y/n): " answer

	#id yes then delete the user
	if [ "$answer" == "y" ]; then
		sudo userdel "$user"
       		echo -e "\e[1;32mThe user '$user' has been deleted succesfully.\e[0m"

	#if no do not delete the user
    	elif [ "$answer" == "n" ]; then
        	echo -e "\e[1;32mThe user '$user' will not be deleted.\e[0m"
    	else
        	echo -e "\e[1;31mInvalid input.\e[0m"
    	fi
  else
    echo -e "\e[1;31mThe user '$user' doesn't exists.\e[0m"
  fi
}

#display user
displayUsers(){
  echo " "
  echo -e "\e[1;95m============================  All Usesrs  ============================\e[0m"
  who
}

#disconnect a remote user
killRemote(){
  echo " "
  echo -e "\e[1;96m==============================  Disconnecting Remote Users  ==============================\e[0m"
  echo "All remote user: "
  who | grep pts | awk '{print $1,$2}'

  read -p "Which user do you want to disconnect: " user

#checking if user exists
   if id "$user" &>/dev/null; then
	#making user input the users pts
        read -p "Please enter $user pts: " pts

        #check if the  pts macths the user
	userPTS=$(who | grep "$user" | awk '{print $2}')
		if [ "$userPTS" == "$pts" ]; then
		   #double checking if they want to disconncet the user
    		   read -p "Are you sure you want to disconnect $user: (y/n) ? " ans
                	if [ "$ans" == "y" ]; then
            		    echo -e "\e[1;32mThe user '$user' disconnected.\e[0m"
            		    sudo pkill -HUP -t "$pts"
                	elif [ "$ans" == "n" ]; then
                    	     echo -e "\e[1;32mThe user '$user' will not be disconnected.\e[0m"
                	else
                    	     echo -e "\e[1;32mInvalid option\e[0m."
                	fi
		else
		  echo -e "/e[1;31mThe pts enter does not match $user pts.\e[0m"
		fi
    else
      echo -e "\e[1;31mUser does not exists.\e[0m"
  fi
}


#show all groups for a user
groupsUser(){
  echo " "
  echo -e "\e[1;93m=======================  Groups Users  ===================\e[0m"
#showing the user all the users so they can pick
  echo "Here are a list of all users: "
  formatOut=$(cut -d: -f1 /etc/passwd | pr -t -a -4)
  echo "$formatOut"

#asking for the user
  read -p "Enter a username you want to see the groups they are in: " user

#check if user exist
  if id "$user" &>/dev/null;then
    echo "All groups $user is in: "
    #getting all group then only displaying the name of the group
    groups "$user" | cut -f2 -d:
  else
    echo -e "\e[1;31mUser does not exists.\e[0m"
  fi
}


#method to add a user to a group
addGroup(){
  echo " "
  echo -e "\e[1;38;5;214m====================================  Adding User to a group  ====================================\e[0m"

  #show all users
  echo "Here are a list of all users: "
  formatOut=$(cut -d: -f1 /etc/passwd | pr -t -a -4)
  echo "$formatOut"

  #ask user for which user
  read -p "Enter a the user you want to add to a group: " user

   if id "$user" &>/dev/null; then
      echo " " #spacing
      #show all groups
      echo "Here are a list of all groups: "
      formatOutput=$(cut -f1 -d":" /etc/group | pr -t -a -4)
      echo "$formatOutput"
      echo " "

      #ask user for group
      read -p "Enter a group you'd like the user to join: " group

      #check if group exists
      if getent group "$group" &>/dev/null 2>&1; then
   	#double checking
        read -p "Are you sure you want to add user $user to group: $group : (y/n) ? " ans
           #if yes add the user to the group if not do not
	   if [ "$ans" == "y" ]; then
                sudo usermod -aG "$group" "$user"
                echo -e "\e[1;32mThe user '$user' has been added to $group group.\e[0m"
           elif [ "$ans" == "n" ]; then
                 echo -e "\e[1;32mThe user '$user' will not be added to the group.\e[0m"
           else
                echo -e "\e[1;31mInvalid option.\e[0m"
           fi
      else
        echo -e "\e[1;31m$group does not exist.\e[0m"
      fi
  else
        echo -e "\e[1;31m$user doesn't exist.\e[0m"
  fi
}


#remove a user from a group
removeGroup(){
  echo " "
  echo -e "\e[1;38;5;212m====================================  Removing User from a group  ====================================\e[0m"
  #show all users
  echo "Here are a list of all users: "
  formatOut=$(cut -d: -f1 /etc/passwd | pr -t -a -4)
  echo "$formatOut"



 #ask user for which user
 read -p "Enter a the user you want to remove from a group: " user

  if id "$user" &>/dev/null;then
    #show the groups the are in
    formatGroup=$(groups "$user" | cut -f2 -d:)
    echo "All groups $user is in: "
    echo "$formatGroup"

    #ask for the group
    read -p "Select the group you want to remove $user from: " group

     #check if group exists
     if getent group "$group" &>/dev/null 2>&1; then

    	#double check if they want to remove the user
        read -p "Are you sure you want to remove $user from the $group : (y/n) ? " ans
           if [ "$ans" == "y" ]; then
                sudo gpasswd -d "$user" "$group"
                echo -e "\e[1;32m$user has been removed from $group.\e[0m"
		return
           elif [ "$ans" == "n" ]; then
                 echo -e "\e[1;32m$user will not be removed from the group.\e[0m"
           else
                echo -e "\e[1;31Invalid option.\e[0m"
           fi
    else
        echo -e "\e[1;31m$group does not exist.\e[0m"
    fi
  else
        echo -e "\e[1;31mThe user '$user' doesn't exist.\e[0m"
  fi
}


#change a user's group membership
groupSudo(){
 echo " "
 echo -e "\e[1;97m================================  Change a user’s group membership =================================\e[0m"
 echo -e "\e[1;38;5;214m1) Add to a new group\e[0m"
 echo -e "\e[1;38;5;212m2) Remove from a group\e[0m"
 echo -e "\e[38;5;51m3) Back to user management\e[0m"
 echo -e "\e[1;37m4) Back to main menu\e[0m"
 echo -e "\e[1;31m5) Exit program\e[0m"

 read -p "Select an option [1-5]: " opt

 case $opt in
        1)
          addGroup
        ;;
        2)
          removeGroup
        ;;
        3)
          echo -e "\e[38;5;51mReturning to user management\e[0m"
          UserManagement
	;;
        4)
         echo -e "\e[1;37mReturning to Main Menu...\e[0m"
          MainMenu
        ;;
	5)
	  echo -e "\e[1;31mEnding program....\e[0m"
	  exit 1
	;;
        *)
         echo -e "\e[1;31mInvalid option.\e[0m"
        ;;
  esac
}



#user management menu
UserManagement(){
while true;do
  echo " "
  echo -e "\e[38;5;51m=======================================  User Management =======================================\e[0m"
  echo -e "\e[1;92m1) Add a user\e[0m"
  echo -e "\e[1;91m2) Grant root permission to a user\e[0m"
  echo -e "\e[1;94m3) Delete a user\e[0m"
  echo -e "\e[1;95m4) Display connected user\e[0m"
  echo -e "\e[1;96m5) Disconnect a remote user\e[0m"
  echo -e "\e[1;93m6) List all groups of a user\e[0m"
  echo -e "\e[1;97m7) Change user's group membership\e[0m"
  echo -e "\e[1;90m8) Return to Main Menu\e[0m"
  echo -e "\e[1;31m9) Exit program\e[0m"
  echo " "

  read -p "Select an option  [1-9]: " option

  case $option in
        1)
          createUser
        ;;
        2)
          rootPerm
        ;;
        3)
          deleteUser
        ;;
        4)
          displayUsers
        ;;
        5)
          killRemote
        ;;
	6)
	  groupsUser
        ;;
        7)
          groupSudo
        ;;
	8)
	  echo -e "\e[1;30mReturning to Main Menu\e[0m"
          MainMenu
	;;
        9)
         echo "End program..."
         exit 1
        ;;
        *)
          echo -e "\e[1;31mInvalid option\e[0m"
        ;;
  esac
done
}

#---------------------------------------File Management--------------------------------------
userAndFileCheck(){
  echo -e "\e[38;5;141m======================  File Check  ===========================\e[0m"
   #asking user for username and check if the user exist
  read -p "Enter an username: " username

  if id "$username" &>/dev/null;then
    #geting the home home directory
    User_Home=$(getent passwd "$username" | cut -d: -f6)

    #asking for the file name
    read -p "Enter a filename: " fileName

    # search for the file inside the user's home directory
    fileResult=$(sudo find "$User_Home" -name "$fileName" -print -quit 2>/dev/null)

    #check if its not empty
	if [[ -n "$fileResult" ]]; then
   	   echo -e "\e[1;32mPath: $fileResult\e[0m"
	else
	   echo -e "\e[1;31mFile not found.\e[0m"
	fi
  else
     echo -e "\e[1;31mUser does not exist.\e[0m"
     return 1
  fi
}



display_large(){
  read -p "Enter a username: " username
  if id "$username" &>/dev/null; then
    User_Home=$(getent passwd "$username" | cut -d: -f6)
    echo -e "\e[38;5;226m========================  10 Largest File  ==========================\e[0m"
    files=$(sudo ls -lSh "$User_Home" | grep -v d | head -n 10 | awk '{print $9}')
    echo -e "\e[1;32m $files\e[0m"
  else
    echo -e "\e[1;31mUser does not exist.\e[0m"
  fi
}


display_old(){
  read -p "Enter a username: " username
  #checking
  if id "$username" &>/dev/null; then
     #get the user's home directory
     User_Home=$(getent passwd "$username" | cut -d: -f6)
    echo -e "\e[38;5;87m======================  10 Oldest File  ==========================\e[0m"
    #get the oldest file with ls -ltr. t sort by time and r, reverse the order so the oldest are on the top
    files=$(sudo ls -ltr "$User_Home" | grep -v d | head -n 10 | awk '{print $9}')
   echo -e "\e[1;32m $files\e[0m"
  else
    echo -e "\e[1;31mUser does not exist.\e[0m"
  fi
}


FileManagement(){
while true; do
  echo " "
  echo -e "\e[38;5;208m=======================================  File Management =======================================\e[0m"
  echo -e "\e[38;5;141m1) Check username and file existes\e[0m"
  echo -e "\e[38;5;226m2) Display the 10 largest files in a user's home directorey\e[0m"
  echo -e "\e[38;5;87m3) Diplay the 10 oldest files in a user's home directory\e[0m"
  echo -e "\e[1;37m4) Back to Main Menu\e[0m"
  echo -e "\e[1;31m5) End Program\e[0m"

  read -p "Select an option [1-5]: " opt

  case $opt in
	1)
	  userAndFileCheck
	;;
	2)
	  display_large
	;;
	3)
	  display_old
	;;
	4)
	  echo -e "\e[1;37mReturning to Main Menu\e[0m"
	  MainMenu
	;;
	5)
	  echo "\e[1;31mEnding program....\e[0m"
	  exit 1
	;;
	*)
	  echo -e "\e[1;31mInvaild option\e[0m"
	;;
  esac
done
}


#running the function

MainMenu
