#!/bin/bash

if [ $# -le 0 ]; then
	echo "Usage: $0 [-qw]"
	echo
fi

l=0

log_c()
{

#Variable ipc contains all the data from the thttpd.log.
ip_d=$(<$1)

#it is converted into expression and grep is used for pattern matching.
ip=$(echo $ip_d |grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}') 

#uniq is used to count the occurances of ip address and sorted them in descending order. 
ip="`echo "$ip" | sort | uniq -c | sort -n -r`" 

#now the ip address and their occurance are printed
ip="`echo "$ip" |awk '{print "-c:  " $2"  "$1 " "}'`"
echo "$ip" | head -n $2


}

log_2()
{
#Variable ipc contains all the data from the thttpd.log.
ip_d=$(<$1)

#it is converted into expression and grep is used for pattern matching and finds number of successful connections.
su_ip=$(echo "$ip_d" | grep "HTTP\/[1]\.[0-1]\" [2][0-9][0-9]" | grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}')

#uniq is used to count the occurances of ip address and sorted them in descending order. 
ip="`echo "$su_ip" | sort | uniq -c | sort -n -r`"

#now the ip address and their successful attempts  are printed
ip="`echo "$ip" | awk '{print "-2:  " $2"  "$1 " "}'`"
echo "$ip" | head -n $1

}

maxl=2


if [ $1 = "-n" ] 
then
	l=$2
	shift 2
fi

if [ $# -gt $maxl ]
then
	echo "Max number of arguemnts is reached"
else
	case $1 in
		-c)
			log_c $2 $l
			;;
		-2)
			log_2 $2
			;;
		-?)
			echo "Please give a command"
			;;
	esac
fi	
