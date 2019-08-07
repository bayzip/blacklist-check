#!/bin/bash

ERROR() {
	echo $0 ERROR: $1 >&2
	exit 2
}

[ $# -ne 1 ] && ERROR 'Please specify a single IP address'

if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] ; then
	changeip=$1	
else
	echo "This is hostname"
	changeip=$(dig +short $1)
fi

reverse=$(echo $changeip | sed -ne "s~^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)$~\4.\3.\2.\1~p")

if [ "x${reverse}" = "x" ] ; then
	ERROR  "IMHO '$changeip' doesn't look like a valid IP address"
	exit 1
fi

REVERSE_DNS=$(dig +short -x $changeip)

echo IP $changeip NAME ${REVERSE_DNS:----}

while read data; do
	printf "%-50s"  " ${reverse}.${data}."
	#echo "$(dig +short -t a ${reverse}.${data}. |  tr '\n' ' ')"
	LISTED="$(dig +short -t a ${reverse}.${data}.)"
	echo ${LISTED:----}
done < "mydata"
