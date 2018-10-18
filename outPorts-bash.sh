#!/bin/bash

progToUse="none"
portBegin="0"
portEnd="0"
portForbid="22 25 222 224 445"
externalServer="portquiz.net"

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

function isNumber() {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]]
	then
		return 1 >&2
	fi
	return 0
}

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

exit 0
