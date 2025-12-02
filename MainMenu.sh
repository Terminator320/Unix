#main menu
MainMenu(){
while true; do
  echo "=======================================  Main Menu  ======================================="
  echo " "
  echo "1) System Status"
  echo "2) Backup Management"
  echo "3) Network Management"
  echo "4) Service Management"
  echo "5) User Management"
  echo "6) File Management"
  echo "7) Exit Program"

  read -p "Select an option [1-7]: " opt
  case $opt in
	1)
	  echo "In development"
	;;
	2)
	  BackupManagement
	;;
	3)
	  echo "In development"
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
	  echo "Ending program..................."
	  exit 1
	;;
	*)
	  echo "Invalid option"
	;;
  esac
done
}



#--------------------------------System Status----------------------------------------



#--------------------------------Backup Management-----------------------------------



#-------------------------------Network Management------------------------------------





#------------------------------Service Management--------------------------------------
#checking function
confirmation(){
  #checking if its active or not
  check=$(systemctl status $1 | awk 'NR==3 {print $2}')

  #if its active user has started it
  if [ "$check" == "active" ];then
     echo "You have started $1"
  #if its not active then user hasn't stop it
  else
    echo "You have stopped $1"
  fi
}

#display all  running service
display(){
#only list the service that's states is running then it only display lines that>
  echo " "
  echo "=======================================  All Running Services  ======================================="
  systemctl list-units --type=service --state=running | grep '.service'
}

#start stop function
startStop(){
  echo " "
  echo "=======================================  Start Or Stop Services ======================================="
  #asking for stop or start
  read -p "Would you like to start or stop a service (start or stop): " startOrStop

  if [ "$startOrStop" != "start" ] && [ "$startOrStop" != "stop" ]; then
    echo "Invalid option. Please enter 'start' or 'stop'."
    return 1
  fi

  #asking for which  service
  read -p "Please enter a service you'd like to $startOrStop: " service

  # Check if service exists
  if ! systemctl show "$service" &>/dev/null; then
	echo "Service '$service' does not exist."
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
           echo "$server will not start."
   	else
	   echo "Invalid Option"
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
	    echo "$service will not be stop."
  	else
	    echo "Invalid option"
   	fi
       break
     done
  else
    echo "Invalid. Please re-enter: (start or stop)"
 fi
}


#Server management menu
Server_Management(){
while true;do
  echo " "
  echo "=======================================  Service Management ======================================="
  echo "1) View all Running Services."
  echo "2) Start and Stop Services."
  echo "3) Return to Main Menu."
  echo "4) Exit the Program."

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
          echo "Exiting the program..."
          exit 1
          ;;
        *)
         echo "Invalid option"
        ;;
  esac
done
}

#--------------------------------------User Management--------------------------------------
#create new user
createUser(){
  echo " "
  echo "============================  Creating Users  ============================"
  read -p "Enter a username: " username

  #check if the user exists
  if id "$username" &>/dev/null; then
     echo "User already exists."
  else
    sudo useradd "$username"
    sudo passwd "$username"
    echo "A new user ($username) has been created."
  fi
}


#root permission
rootPerm(){
echo " "
echo "============================ Grant Root Premission  ============================"
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
	   echo "The user $user now has sudo permission."
	 elif [ "$ans" == "n" ]; then
	   echo "$user will not be given sudo permission."
	else
	  echo "Invalid option."
	fi
	return
    done
  else
    echo "The user $user does not exists"
fi
}


#Deleting a user
deleteUser() {
  echo " "
  echo "============================  Deleting Users  ============================"
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
       		echo "$user has been deleted succesfully."

	#if no do not delete the user
    	elif [ "$answer" == "n" ]; then
        	echo "$user will not be deleted."
    	else
        	echo "Invalid input."
    	fi
  else
    echo "$user doesn't exists."
  fi
}

#display user
displayUsers(){
  echo " "
  echo "============================  All Usesrs  ============================"
  who
}

#disconnect a remote user
killRemote(){
  echo " "
  echo "==============================  Disconnecting Remote Users  =============================="
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
            		    echo "$user disconnected."
            		    sudo pkill -HUP -t "$pts"
                	elif [ "$ans" == "n" ]; then
                    	     echo "$user will not be disconnected."
                	else
                    	     echo "Invalid option."
                	fi
		else
		  echo "The pts enter does not match $user pts."
		fi
    else
      echo "User does not exists."
  fi
}


#show all groups for a user
groupsUser(){
echo " "
echo "=======================  Groups Users  ================="
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
    echo "User does not exists."
  fi
}


#method to add a user to a group
addGroup(){
  echo " "
  echo "====================================  Adding User to a group  ===================================="

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
                echo "$user has been added to $group group."
           elif [ "$ans" == "n" ]; then
                 echo "$user will not be added to the group."
           else
                echo "Invalid option."
           fi
      else
        echo "$group does not exist."
      fi
  else
        echo "$user doesn't exist."
  fi
}


#remove a user from a group
removeGroup(){
  echo " "
  echo "====================================  Removing User from a group  ===================================="
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
                echo "$user has been removed from $group."
		return
           elif [ "$ans" == "n" ]; then
                 echo "$user will not be removed from the group."
           else
                echo "Invalid option."
           fi
    else
        echo "$group does not exist."
    fi
  else
        echo "$user doesn't exist."
  fi
}


#change a user's group membership
groupSudo(){
 echo " "
 echo "================================  Change a user’s group membership ================================="
 echo "1) Add to a new group"
 echo "2) Remove from a group"
 echo "3) Back to user management"
 echo "4) Back to main menu"
 echo "5) Exit program"

 read -p "Select an option [1-5]: " opt

 case $opt in
        1)
          addGroup
        ;;
        2)
          removeGroup
        ;;
        3)
          echo "Returning to user management"
          UserManagement
	;;
        4)
         echo "Returning to Main Menu"
          MainMenu
        ;;
	5)
	  echo "Ending program...."
	  exit 1
	;;
        *)
         echo "Invalid option."
        ;;
  esac
}



#user management menu
UserManagement(){
while true;do
  echo " "
  echo "=======================================  User Management ======================================="
  echo "1) Add a user"
  echo "2) Grant root permission to a user"
  echo "3) Delete a user"
  echo "4) Display connected user"
  echo "5) Disconnect a remote user"
  echo "6) List all groups of a user"
  echo "7) Change user's group membership"
  echo "8) Return to Main Menu"
  echo "9) Exit program"
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
	  echo "Returning to Main Menu"
          MainMenu
	;;
        9)
         echo "End program..."
         exit 1
        ;;
        *)
          echo "Invalid option"
        ;;
  esac
done
}

#---------------------------------------File Management--------------------------------------
userAndFileCheck(){
  echo "======================  File check  ==========================="
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
   	   echo "Path: $fileResult"
	else
	   echo "File not found."
	fi
  else
     echo "User does not exist."
     return 1
  fi
}



display_large(){
  read -p "Enter a username: " username
  if id "$username" &>/dev/null; then
    User_Home=$(getent passwd "$username" | cut -d: -f6)
    echo "==========================  10 Largest File  =========================="
    sudo ls -lSh "$User_Home" | grep -v d | head -n 10 | awk '{print $9}'
  else
    echo "User does not exist."
  fi
}


display_old(){
  read -p "Enter a username: " username
  #checking
  if id "$username" &>/dev/null; then
     #get the user's home directory
     User_Home=$(getent passwd "$username" | cut -d: -f6)
    echo "==========================  10 Oldest File  =========================="
    #get the oldest file with ls -ltr. t sort by time and r, reverse the order so the oldest are on the top
    sudo ls -ltr "$User_Home" | grep -v d | head -n 10 | awk '{print $9}'
  else
    echo "User does not exist."
  fi
}


FileManagement(){
while true; do
  echo " "
  echo "=======================================  File Management ======================================="
  echo " "
  echo "1) Check username and file existes"
  echo "2) Display the 10 largest files in a user's home directorey"
  echo "3) Diplay the 10 oldest files in a user's home directory"
  echo "4) Back to Main Menu"
  echo "5) End Program"

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
	  echo "Returning to Main Menu"
	  MainMenu
	;;
	5)
	  echo "Ending program...."
	  exit 1
	;;
	*)
	  echo "Invaild option"
	;;
  esac
done
}


#running the function

MainMenu
