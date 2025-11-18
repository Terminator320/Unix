userChecker(){
if id "$1" &>/dev/null;then
   echo "User exists. Continuing"
else
   echo "User does not exist. Exiting"
   return 1
fi
}

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
  echo "A new user has been create"
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


#display all user 
displayUsers(){
who
}

#disconnect a remote user
killRemote(){
  echo "Not done"
}


groupsUser(){
read -p "Enter a username you want to display all groups for" user
userChecker $user
getent group | grep $user | cut -f1 -d:
}
groupSudo(){
  echo "ASk teacher"
}

#user management menu
UserManagement(){
while true;do
  echo "1) Add a user"
  echo "2) Grant root permission to a user"
  echo "3) Delete a user"
  echo "4) Display connected user"
  echo "5) Disconnect a remote user"
  echo "6) List all groups of a user"
  echo "7) Change user's group membership"
  echo "8) Exit program"
  echo " "

  read -p "Select an option  [1-8]: " option

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
	 echo "End program..."
	 exit 1
	;;
	*)
	  echo "Invaild option"
	;;
  esac
done 
}


UserManagement
