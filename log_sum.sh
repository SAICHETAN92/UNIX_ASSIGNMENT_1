#!/bin/bash

if [ $# -le 0 ]; then
	echo "Usage: $0 [-qw]"
	echo
fi

l=0

log_c()
{

#Variable ip_d contains all the data from the thttpd.log.
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
#Variable ip_d contains all the data from the thttpd.log.
ip_d=$(<$1)

#it is converted into expression and grep is used for pattern matching and finds number of successful connections.
su_ip=$(echo "$ip_d" | grep "HTTP\/[1]\.[0-1]\" [2][0-9][0-9]" | grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}')

#uniq is used to count the occurances of ip address and sorted them in descending order. 
ip="`echo "$su_ip" | sort | uniq -c | sort -n -r`"

#now the ip address and their successful attempts  are printed
ip="`echo "$ip" | awk '{print "-2:  " $2"  "$1 " "}'`"
echo "$ip" | head -n $1

}

log_r()
{
#Variable ip_d contains all the data from the thttpd.log.
ip_d=$(<$1)

#Argument 9 indicates status code, ip address are sorted as per status code
st_cod="`echo "$ip_d"| awk '{print $9}' | sort |uniq -c| sort -n -r`"

# status codes are matched using grep command
st_cod=$(echo "$st_cod"| grep "[2-4][0][0-4]" | grep -Eo "[2-4][0][0-4]")

#for loop is used to print all ip addresses under specific status code
      	for code in $st_cod;
	do
                #printing status code
		echo $code
                
		#match all the ip addresses with specific status code
		s_ip=$(echo "$ipc" | grep "HTTP\/[1]\.[0-1]\" $code" | awk '{print $1,$9}')
                
		#match all the ip addresses with specific status code
	        result="`echo "$s_ip"| sort | uniq -c | sort -nr |awk '{print "-r : "$3"  "$2 " "}'`"
                echo "$result" | head -n $l 
		
	done

}

log_F()
{

#Variable ip_d contains all the data from the thttpd.log.
ip_d=$(<$1)

#matching the status code with connection
st_cod=$(echo "$ipc"|grep  "HTTP\/[1]\.[0-1]\" [4][0][0-4]")

#storing the values of status code 
st_cod=$(echo "$status_code" | awk '{print $9}')

#sorting the staus codes
st_cod="`echo "$status_code" | sort| uniq -c| sort -nr | awk '{print $2}'`"

#for loop is used to print the status code under the specific status code
	for code in $status_code;
	do
                #printing status code
		echo $code
               
	       #match all the ip addresses with specific status code
		s_ip=$(echo "$ipc" | grep "HTTP\/[1]\.[0-1]\" $code" | awk '{print $1,$9}')
               
	       #match all the ip addresses with specific status code
		result=$(echo "$s_ip"| sort|uniq -c | sort -n -r| awk '{print "-r : "$3"  " $2 " "}')
		echo "$result" | head -n $l
		
	done		        
}

log_t()
{

#Variable IP_Data contains all the data from the thttpd.log.
IP_Data=$(<$1)

#it captures the ip address along with the number of bytes tranmitted
store_IPByte=$(echo "$IP_Data" | awk '{print $1,$10}'| sort -k1,1)
#echo "$store_IPByte"

#it removes all failed connections
store_IPByte="`echo "$store_IPByte" |awk '{print $1,$2}'|grep -v "-"`"
#echo "$store_IPByte"

#it sort every ip address in decresing order
store_IP=$(echo "$store_IPByte" |awk '{print $1}'| sort | uniq |sort -nr| awk '{print $1}')
#echo "$store_IP"

	declare -A Lst_IP
	#for loop is used to add up all the byte transmitations under similar ip address.
	for IP in ${store_IP[@]};
	do
		sum=0
		byte=$(echo "$store_IPByte"|grep "$IP"|awk '{print $2}' )
	
		for val in ${byte[@]};
		do
			sum=$(expr $sum + $val)
		done
		Lst_IP[$IP]=$sum 
	done	
	
                # this for loop is used to print the ip address along with the number of byte transmissions.   
		for IP in ${!Lst_IP[@]}; 
		do
			echo -e "-t:$IP   ${Lst_IP[$IP]} where ${Lst_IP[$IP]} is the number of bytes sent from the server"
		done | sort -k2 -r -n | head -n $l	
	 

}


maxl=2


if [ $1 = "-n" ] 
then	
	l=$2
	shift 2
fi

if [ $# -gt $maxl ]
then
	echo "Maximum number of arguemnts is reached"
else
	case $1 in
		-c)
			
			log_c $2 $l
			;;
		-2)
			log_2 $2
			;;
		-r)
			log_r $2
			;;
		-F)
			log_F $2
			;;
		-t)
			log_t $2
			;;

		-?)
			echo "U should give me a command"
			;;
	esac
fi	
