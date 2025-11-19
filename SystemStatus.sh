getMemoryInfo(){
total=$(free -h | awk 'NR==2 {print $2}')
used=$(free -h | awk 'NR==2 {print $3}')
available=$(free -h | awk 'NR==2 {print $7}')
echo "The total memory is $total and $used is used. There is $available of memory available."
}
listActive(){
list=$(ps -aux | awk ' {print $1,$2,$11}')
echo "$list"
}

killProcess(){
ps -aux
read -p "Which process do you want to kill. Use the PID to kill it." killID

sudo kill -9  $killID
echo "Killed that procress for you"
}
listActive
getMemoryInfo
killProcess
