# UNIX_ASSIGNMENT_1

## Assignment - 1  Shell Scripting

### The basic aim of this assignment is write a shell script to process a log file. The log file considered in the assignment is a web server log file from the small, portable and secure webserver thttpd. The basic idea is that this shell-script will be used by system admins to extract and summarise relevant information about the operation of the webserver.
### The logfile consists of some text where each line represent an access request. It follows the unified Apache combined log format. The fields, describe the following: IP Address, the request originated from; the ident answer from the originator, the username of the requester as determined by http authentication, date and time the request was processed, the request line asit was received from the client in double quotes, http status code that was sent to the client, number of bytes that was transferred to the client, referer page (from the client), user agent string.

## Task of the Shell Script

### A shell script that reads a log file and answers the following questions:
- Which IP addresses makes the most number of connection attempts?
- Which IP addresses makes the most number of successful connectionattempts?
- What are the most common result codes and where do they come from (IP number)?
- What are the most common result codes that indicate failure (no auth, not found etc) 
- Where do they come from?•Which IP number get the most bytes sent to them?

## Arguments

### The arguments to the shell script should be coded as such:
### log_sum.sh [-n N] (-c|-2|-r|-F|-t) <filename>
- -n: Limit the number of results to N
- -c: Which IP address makes the most number of connection attempts?
- -2: Which address makes the most number of successful attempts?
- -r: What are the most common results codes and where do they comefrom?
- -F: What are the most common result codes that indicate failure (noauth, not found etc) and where do they come from?
- -t: Which IP number get the most bytes sent to them?
  
### Everything is sorted in the decreasing order
  
## Explanation of the Shell Script.
  
### The shell used is BASH (Bourne Again Shell) Shell. The first line `#!/bin/bash` indicates the location of the BASH.
### The script can be further divided into different logs as per the requirement. The first log is log_c and it is used to find out which IP address made the most number of connection attempts. The program is given below:
```
log_c()
{

#Variable IP_Data contains all the data from the thttpd.log.
IP_Data=$(<$1)

#It is converted into expression and grep is used for pattern matching.
IP_Addr=$(echo $IP_Data |grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}') 

#uniq is used to count the occurances of ip address and sorted them in descending order. 
IP_Addr="`echo "$IP_Addr" | sort | uniq -c | sort -n -r`" 

#Now the ip address and their occurance are printed
IP_Addr="`echo "$IP_Addr" |awk '{print "-c:  " $2"  "$1 " where "$1" is the number of connection attempts "}'`"
echo "$IP_Addr" | head -n $2

}

```
### In the code given above data from the log file thttpd.log is taken by IP_Data. Then the data is converted into expression foe easy comparision. GREP (Globally Search a Regular Expression and Print) is used to search set of strings from the data and match them (Pattern Matching). An IP address basicaly contains four set of numbers separated by a '.' and each set varies from one digit to three digits. The line `[[:digit:]]{1,3}` conatins a set of one digit number to a three digit numbers Example of an IP address is "213.64.214.124". Then Uniq comand is used to count number of connections but it is mandatory to sort it before we apply uniq to get accurate results, then as per requirement the data must be sorted in decreasing order, so it is sorted in a reverse order. And finally the required columns are printed as statements using awk.

### Every IP address makes a connection attempt but we cannot assure that every connection attempt made is a successful attempt. The next log is log_2 and it is used to find the IP adress that makes the most number of successful connection attempts. The program is given below:
```
log_2()
{
#Variable IP_Data contains all the data from the thttpd.log.
IP_Data=$(<$1)

#It is converted into expression and grep is used for pattern matching and finds number of successful connections.
IP_Success=$(echo "$IP_Data" | grep "HTTP\/[1]\.[0-1]\" [2][0-9][0-9]" | grep -Eo '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}')

#uniq is used to count the occurances of ip address and sorted them in descending order. 
IP_Addr="`echo "$IP_Success" | sort | uniq -c | sort -n -r`"

#Now the ip address and their successful attempts  are printed
IP_Addr="`echo "$IP_Addr" | awk '{print "-2:  " $2"  "$1 " where "$1" is the number of  successful attempts"}'`"
echo "$IP_Addr" | head -n $l

}

```
### In the code given above data from the log file thttpd.log is taken by IP_Data. Then the data is converted into expression foe easy comparision. GREP (Globally Search a Regular Expression and Print) is used to search set of strings from the data and match them (Pattern Matching). To find if an IP address made a successful attempt, status codes are used. The status code is a three digit code to show the information regarding the connection. A status code of format "2XX" is said to have made a scuccessful atempt. So, the status codes starting with 2 need to be searched. But there might be other three digit numbers starting with 2. So, it is searched with a statement HTTP followed by version followed by the status code (eg. HTTP/1.1 200) to get the accurate results. Then Uniq command is used to count and it is sorted in decreasing order. Finally the required columns are printed as statements using awk.
  
### There are several status code, one indicates "page not found", other indicates "unauthorised atempt" etc. Almost every connection attempts returns a status code. The next log is log_r and it is used to find the most common status codes and where do they come from? The program is given below:
```
log_r()
{
#Variable IP_Data contains all the data from the thttpd.log.
IP_Data=$(<$1)

#Argument 9 indicates status code, IP address are sorted as per status code
Result_code="`echo "$IP_Data"| awk '{print $9}' | sort |uniq -c| sort -n -r`"

# Result codes are matched using grep command
Result_code=$(echo "$Result_code"| grep "[2-4][0][0-4]" | grep -Eo "[2-4][0][0-4]")

#for loop is used to print all ip addresses under specific Result code
      	for code in $Result_code;
	do
                #printing status code
		echo $code
		
                #match all the ip addresses with specific status code
		IP_Success=$(echo "$IP_Data" | grep "HTTP\/[1]\.[0-1]\" $code" | awk '{print $1,$9}')
		
                #match all the ip addresses with specific status code
	        result="`echo "$IP_Success"| sort | uniq -c | sort -nr |awk '{print "-r : "$3"  "$2 "where "$3" is the result code "}'`"
                echo "$result" | head -n $l" 
		
	done

}

```
### In the code given above data from the log file thttpd.log is taken by IP_Data. Then the data is converted into expression foe easy comparision. GREP (Globally Search a Regular Expression and Print) is used to search set of strings from the data and match them (Pattern Matching). In the log file Ninteh column consists of the status codes, so initially they are sorted. Generally status codes are 20X, 30X, 40X, so among all the the numbers only these numbers are considered `grep "[2-4][0][0-4]"` and searched using GREP command. After that a for loop is used to identify all the IP addresses under the specified status codes. Inside the for loop GREP is used for pattern matching and searching for ststus codes. But there might be other three digit numbers in the format 20X, 30X, 40X. So, it is searched with a statement HTTP followed by version followed by the status code (eg. HTTP/1.1 200) to get the accurate results. Then Uniq command is used to count and it is sorted in decreasing order. Finally the required columns are printed as statements using awk.

### There are several status code, one indicates "page not found", other indicates "unauthorised atempt" etc. Such status codes indicates failure in connection attempt. The next log is log_F and it is used to find the IP address with a status code indicating the failure. The program is given below:
```
log_F()
{
	       
#Variable IP_Data contains all the data from the thttpd.log.
IP_Data=$(<$1)

#matching the status code with connection
Result_code=$(echo "$IP_Data"| grep  "HTTP\/[1]\.[0-1]\" [4][0][0-4]")

#storing the vals of Result code 
Result_code=$(echo "$Result_code" | awk '{print $9}')

#sorting the staus codes
Result_code="`echo "$Result_code" | sort| uniq -c| sort -nr | awk '{print $2}'`"

#for loop is used to print the status code under the specific status code
	for code in $Result_code;
	do
                #printing Result code
		echo $code
		
                #match all the ip addresses with specific Result code
		IP_Success=$(echo "$IP_Data" | grep "HTTP\/[1]\.[0-1]\" $code" | awk '{print $1,$9}')
		
                #match all the ip addresses with specific status code
		result=$(echo "$IP_Success"| sort|uniq -c | sort -n -r| awk '{print "-r : "$3"  " $2 " where " $3" is the result code indicating failure  "}')
		echo "$result" | head -n $l

	done		        
}

```
### In the code given above data from the log file thttpd.log is taken by IP_Data. Then the data is converted into expression foe easy comparision. GREP (Globally Search a Regular Expression and Print) is used to search set of strings from the data and match them (Pattern Matching). In the log file Ninteh column consists of the status codes, so initially they are sorted. Generally the status codes of format 4XX indicates the failure in connection attempt, so among all the the status codes only these codes of format 4XX are considered `grep  "HTTP\/[1]\.[0-1]\" [4][0][0-4]" ` and searched using GREP command. After that a for loop is used to identify all the IP addresses under the status codes 4XX. Inside the for loop GREP is used for pattern matching and searching for ststus codes. But there might be other three digit numbers in the format 4XX. So, it is searched with a statement HTTP followed by version followed by the status code (eg. HTTP/1.1 404) to get the accurate results. Then Uniq command is used to count and it is sorted in decreasing order. Finally the required columns are printed as statements using awk.

### The Log file contains number of bytes transmitted by each IP address. The next log is log_t and it is used to find the sent from the serevr. The program is given below:
```
log_t()
{
	
#Variable IP_Data contains all the data from the thttpd.log.
IP_Data=$(<$1)

#it captures the ip address along with the number of bytes tranmitted
store_IPByte=$(echo "$IP_Data" | awk '{print $1,$10}'| sort -k1,1)

#echo "$store_IPByte"
#it removes all failed connections
store_IPByte="`echo "$store_IPByte" |awk '{print $1,$2}'| grep -v "-"`"

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


```
### In the code given above data from the log file thttpd.log is taken by IP_Data. Then the data is converted into expression foe easy comparision. GREP (Globally Search a Regular Expression and Print) is used to search set of strings from the data and match them (Pattern Matching). Number of bytes sent from the server are given in the tenth column of the log file. Initally the IP addresses and the bytes transmitted are stored. But we cannot proceed further with this data because, only successful connections have number of bytes transmitted rest of the IP address have empty data. The IP address with a failed connection or 0 bytes must be removed. For this inverted GREP `grep -v` is used. It identifies the unmatched patterns and they are removed. Thus the IP addresses with Transmitted byte are only considered. There is a chance that an IP addrees with several connections has transmitted multiple bytes, they must be added. To identify the sum a for loop is used. Thus, the accurate results are obtained. Then Uniq command is used to count and it is sorted in decreasing order. Finally the required columns are printed as statements using another for loop

### All the above mentioned log files are called in the program is given below:
```
axl=2


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
			echo "Please give a command"
			;;
	esac
fi	

```
### Thus specified operations on log file is done as per the instructions using Shell Scripting. More details about the instructions are mentioned in the file specifications.pdf. 
