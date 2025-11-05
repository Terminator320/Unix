userChecker(){
if id "$1" &>/dev/null
then
echo "User exists. Continuing"
else
echo "User does not exist. Exiting"
return 1
fi
}

createUser(){
read -p "Enter a username" username
sudo useradd -m $username
sudo passwd $username 

if id "$username" &>/dev/null
then
echo "Account created"
else
echo "Account not created"
fi
}

deleteUser(){
read -p "Enter a user to delete." user
userChecker $user
sudo userdel  $user
echo "User deleted"
}
grantRoot(){
read -p "Enter a username you want to grand root to" user
userChecker $user

}
displayUsers(){
who
}
groupsUser(){
read -p "Enter a username you want to display all groups for" user
userChecker $user
getent group | grep $user | cut -f1 -d:

}
groupSudo(){

}

select cnt in CreateUser DeleteUser GrantRoot groupsUser Exit
do
case $cnt in
CreateUser)
createUser
;;
DeleteUser)
deleteUser
;;
GrantRoot)
grantRoot
;;
groupsUser)
groupsUser
;;
Exit)
return 1
;;
*) echo "Choose a valid one"
;;
esac
done
