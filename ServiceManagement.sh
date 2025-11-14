#extra function 
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
#only list the service that's states is running then it only display lines that contain .service then output only the first colunm
  echo " "
  echo "=============================  All Running Services  ============================="
  systemctl list-units --type=service --state=running | grep '.service' | awk '{print $1}'
}

#start stop function
startStop(){
echo " "
echo "==========  Start Or Stop Services =========="
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
  echo "=============================  Service Management ============================="
  echo "1) View all Running Services"
  echo "2) Start and Stop Services."
  echo "3) Exit the Program."

  read -p "Select an option [1-3]: " option

  case $option in 
	 1)
	  display
	 ;;
 	 2)
	  startStop
	 ;;
	 3)
	  echo "Exiting the program..."
	  exit 1
	;;
	*)
	 echo "Invaild option"
	;;
  esac
done
}


Server_Management
