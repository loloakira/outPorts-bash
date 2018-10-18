#!/bin/bash
#
# Description:  This script is made to test a range of outgoing ports using an external server.
#               By default, it's done using portquiz.net from port 1 to 65535
#               Portquiz.net has some port already in use. For that reason, the script take a list of forbidden ports that will not be tested
#
# Author:   Laurent SANSELME
# Date:     2018 - 10 - 19
# Version:  0.1


# Variable to edit if wanted
portForbid="22 25 222 224 445"
externalServer="portquiz.net"

# Global variables
progToUse="none"
portBegin="0"
portEnd="0"


# Function testing if a number is in a list
function isInList() {
    list=${1}
    number=${2}
    for toTest in ${list[@]}
    do
        if [ $toTest -eq $number ] ; then
            return 0
        fi
    done
    return 1
}

# Function testing if a variable is a number (Integer only)
function isNumber() {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]]
	then
		return 1 >&2
	fi
	return 0
}

# Function displaying script usage and exiting with code 1
function usage() {
	echo "outPorts-bash is made to test a range of outgoing ports"
	echo "Usage:"
	echo "$0 with options"
	echo "-c : Tests will be made with curl"
	echo "-w : Tests will be made with wget"
	echo "-b <num> : Numeric value of the first port in range to test"
	echo "-e <num> : Numeric value of the last port in range to test"
	echo "Ending port must be greater or equal to Begining port"
	echo "curl and wget can't be used at the same time"
	exit 1
}

# Function executing the command with curl in the defined ports range
function executeWithCurl() {
	for portNum in $(seq $portBegin $portEnd)
	do
		if isInList "${portForbid[@]}" $portNum
		then
			echo "Port $portNum forbidden"
		else
			curl -s $externalServer:$portNum | head -n 1
		fi
	done
}

# Function executing the command with wget in the defined ports range
function executeWithWget() {
	for portNum in $(seq $portBegin $portEnd)
	do
		if isInList "${portForbid[@]}" $portNum
		then
			echo "Port $portNum forbidden"
		else
			wget -qO- $externalServer:$portNum | head -n 1
		fi
	done
}



# Testing and verifying options passed in arguments
while getopts "cnwb:e:" opt
do
	case $opt in
		c)
			if [ $progToUse = "none" ]
			then
				progToUse="curl"
			else
				usage
			fi
			;;
		w)
			if [ $progToUse = "none" ]
			then
				progToUse="wget"
			else
				usage
			fi
			;;
		b)
			if [ $portBegin -eq 0 ] && isNumber $OPTARG
			then
				portBegin=$OPTARG
			else
				usage
			fi
			;;
		e)
			if [ $portEnd -eq 0 ] && isNumber $OPTARG
			then
				portEnd=$OPTARG
			else
				usage
			fi
			;;
		\?)
			usage
			;;
	esac
done

# Analyze the program to use and execute it with default ports if none were specified
if [ $progToUse = "none" ]
then
	usage
else
	if [ $portBegin -eq 0 ]
	then
		portBegin=1
	fi
	if [ $portEnd -eq 0 ]
	then
		portEnd=65535
	fi
	if [ $portEnd -ge $portBegin ]
	then
		case $progToUse in
			"curl")
				executeWithCurl
				;;
			"wget")
				executeWithWget
				;;
			*)
				echo "WUT ???"
				usage
				;;
		esac
	else
		echo "ERROR: Begining port greater than ending port"
		usage
	fi
fi

# Exit program once done
exit 0
