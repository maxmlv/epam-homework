#!/bin/bash

function listAllHosts() {
	echo "All hosts in subnet:"
	arp -a | awk '{print $1"  "$2}'
}

function listAllTcpPorts() {
	echo "Open TCP ports:"
	netstat -lnt
} 

case $1 in
	"")
		echo "You need to specify command:"
		echo "	--all - displays the IP addresses and symbolic names of all hosts in the current subnet."
		echo "	--target - displays a list of open system TCP ports."
		;;
	"--all")
		listAllHosts
		;;
	"--target")
		listAllTcpPorts
		;;
esac	
