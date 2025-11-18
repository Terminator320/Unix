#main menu
MainMenu(){
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
	  echo "In development"
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
	  echo "Invaild option"
	;;
esac
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
  echo "You have stop $1"
fi
}

#display all  running service
display(){
#only list the service that's states is running then it only display lines that>
  echo " "
  echo "=======================================  All Running Services  ======================================="
  systemctl list-units --type=service --state=running | grep '.service' | awk '{print $1}'
}

#start stop function
startStop(){
echo " "
echo "=======================================  Start Or Stop Services ======================================="
#asking for stop or start
read -p "Would you like to start or stop a service (start or stop): " startOrStop

#asking for which  service
read -p "Please enter a service you'd like to $startOrStop: " service

#checking if the user entered start
if [ "$startOrStop" == "start" ]; then
  #double check if user want to start the service
  read -p "Are you sure you want to start: $service? (y/n):  " answer
    if [ "$answer" == "y" ]; then
        #starting service
        systemctl start $service
        confirmation $service
   else
        echo "$server will not start."
   fi
elif [ "$startOrStop" == "stop" ]; then
  #double check if user wants to stop the service
  read -p "Are you sure you want to stop: $service ? (y/n): " ans
  if [ "$ans" == "y" ]; then
        #stopping service 
        systemctl stop $service
        confirmation $service
  else
    echo "$service will not be stop"
  fi
else
  echo "Invaild. Please re-enter: (start or stop)"
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
         echo "Invaild option"
        ;;
  esac
done
}

#--------------------------------------User Management--------------------------------------
#create new user
createUser(){
read -p "Enter a username" username

#check if the user exists
if id "$username" &>/dev/null; then
   echo "User already exists."
else
  sudo useradd $username
  sudo passwd $username 
#checking if the user inputed a password
  while passwd $username $? -eq 0; do
     echo "Password not vailde. Please try again."
     sudo passwd $username
  done
  echo "A new user has been created."
fi
}

#root permission 
rootPerm(){
#showing the user all the users sp they can pick
  echo "Here are a list of all users: "
  cut -d: -f1 /etc/passwd

  read -p "PLease enter a user you'd want to give root permission: " user
  #check if the user exists or not
  if id $user $>dev/null;then
    #adding root perms to the user 
    sudo usermod -aG root $user
    echo "The user $user now has root permission."
  else
    echo "The user $user does not exists"
fi
}


#Deleting a user
deleteUser() {
#showing the user all the users so they can pick
  echo "Here are a list of all users: "
  cut -d: -f1 /etc/passwd

read -p "PLease enter a user you'd want to delete: " user
  #check if the user exists or not
  if id $user $>dev/null; then
  #double checking if they want to delete the user
  read -p "Are you sure you want to delete the user: $user ?   (y/n): " answer
    #id yes then delete the user
    if [ "$answer" == "y" ]; then
       sudo userdel $user
       echo "$user has been deleted succesfully."
    #if no do not delete the user
    elif [ "$answer" == "n" ]; then
       echo "$user will not be deleted."
    else
       echo "Invaild input."
    fi
  else
    echo "$user doesn't exists."
  fi
}

#display user
displayUsers(){
who | awk '{print $1}'
}

#disconnect a remote user
killRemote(){
  echo "Not done"
}


#show all groups for a user
groupsUser(){
#showing the user all the users so they can pick
  echo "Here are a list of all users: "
  cut -d: -f1 /etc/passwd

#asking for the user 
  read -p "Enter a username you want to display all groups for: " user

#using method to check if user exist
  userChecker $user

#getting all group then only displaying the name of the group
  getent group | grep $user | cut -f1 -d:
}


#chcking method
userChecker(){
if id "$1" &>/dev/null;then
   echo "User exists. Continuing.........."
else
   echo "User does not exist. Exiting.........."
   return 1
fi
}


#change a user's group membership
groupSudo(){
  echo "Ask teacher"
}


#user management menu
UserManagement(){
while true;do
  echo " "
  echo "=====================================================  User Management  ================================================"
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
	  echo "In devplomenple"
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
          echo "Invaild option"
        ;;
  esac
done
}

#---------------------------------------File Management--------------------------------------
get_input(){
#asking user for username and check if the user exist
read -p "Enter an username: " username
if id "$username" &>/dev/null;then
#asking for the file name
  read -p "Enter a filename: " fileName
#make a varible and it uses the find command that will look in the /home/user directory and look for the file and give the path name
 file_path=$(find "/home/$username" -name $fileName)
  #check if its not empty
  if [ -n "$file_path" ];then
	echo "$file_path"
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
    echo "==========================  10 Oldest File  =========================="
    sudo ls -l /home/$username | awk ' {print $5,$9} ' | sort -n |cut -f2 -d" " |  tail
  else
    echo "User does not exist."
  fi
}


display_old(){
  read -p "Enter a username: " username
  #checking
  if id "$username" &>/dev/null; then
    echo "==========================  10 Oldest File  =========================="
    sudo ls -l -t /home/$username | tail | awk '{print $9}'
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
  echo "2) Display the 10 largest files in home directorey"
  echo "3) Diplay the 10 oldest files in a user's home directory"
  echo "4) Back to Main Menu"
  echo "5) End Program"

  read -p "Select an option [1-5]: " opt

  case $opt in
	1)
	  get_input
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
