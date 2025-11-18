userChecker(){
if id "$1" &>/dev/null
then
echo "User exists. Continuing"
else
echo "User does not exist. Exiting"
return 1
fi
}
get_input(){
read -p "Enter an username" username
userChecker $username
read -p "Enter a filename" fileName
file_path=$(find "/home/$username" -name $fileName)
if [ -n "$file_path" ]
then
echo "$file_path"
else
echo "Not found"
fi
}
display_large(){
read -p "Enter a username" username
sudo ls -l /home/$username | awk ' {print $5,$9} ' | sort -n |cut -f2 -d" " |  tail  
}
display_old(){
read -p "Enter a username" username
sudo ls -l -t /home/$username  | tail | awk '{print $9}' 
}

select cnt in FileVerify LargestFiles OldestFiles Exit

do
case $cnt in
FileVerify)
get_input
;;
LargestFiles)
display_large
;;
OldestFiles)
display_old
;;
Exit)
exit 1
;;
*) echo "Enter a valid one"
;;
esac
done
