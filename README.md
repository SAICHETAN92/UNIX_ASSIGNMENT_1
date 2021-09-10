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

```
### In the code given above data from the log file thttpd.log is taken by ip_d. Then the data is converted into expression foe easy comparision. GREP (Globally Search a Regular Expression and Print) is used to search set of strings from the data and match them (Pattern Matching). An IP address basicaly contains four set of numbers separated by a '.' and each set varies from one digit to three digits. Example of an IP address is "213.64.214.124". Then Uniq comand is used to count number of connections but it is mandatory to sort it before we apply uniq to get accurate results, then as per requirement the data must be sorted in decreasing order, so it is sorted in a reverse order. An finally the required columns are printed as statements using awk.
