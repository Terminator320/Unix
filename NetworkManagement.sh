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

NetworkManagement
