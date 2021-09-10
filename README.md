# UNIX_ASSIGNMENT_1

## Assignment - 1  Shell Scripting

### The basic aim of this assignment is write a shell script to process a log file. The log file considered in the assignment is a web server log file from the small, portable and secure webserver thttpd. The basic idea is that this shell-script will be used by system admins to extract and summarise relevant information about the operation of the webserver.
### The logfile consists of some text where each line represent an access request. It follows the unified Apache combined log format. The fields, describe the following: IP Address, the request originated from; the ident answer from the originator, the username of the requester as determined by http authentication, date and time the request was processed, the request line asit was received from the client in double quotes, http status code that was sent to the client, number of bytes that was transferred to the client, referer page (from the client), user agent string.

## Task of the Shell Script

### A shell script that reads a log file and answers the following questions:
- Which IP addresses makes the most number of connection attempts?
- Which IP addresses makes the most number of successful connectionattempts?
- What are the most common result codes and where do they come from(IP number)?
- What are the most common result codes that indicate failure (no auth,not found etc) 
- Where do they come from?•Which IP number get the most bytes sent to them?
