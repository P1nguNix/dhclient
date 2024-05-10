#!/bin/bash
# Objectif : Recréer la commande dhclient sur Linux
# Works only for macOS
# Created by SCHMITT Paul
if [ "$EUID" -ne 0 ] # Verifying that the program is executed with sudo privileges
then
	echo "This program requires sudo privileges."
	exit 1
fi
help(){ # Help Function
	echo -e "usage: dhclient [ -r <interface> | -d <interface> | -m <interface> ] [ -h ]"
	echo -e " -r stand for releasing your actual lease"
	echo -e " -m stand for setting manually your IP address and Subnet Mask"
	echo -e " -d stand for setting dynamicly your IP address and Subnet Mask via DHCP Algorithm"
	echo -e " -h stand for printing this actual help message"
}
while getopts ":m:r:d:h" option
# getopts: Specifying a colon (:) after a character causes the shell to query an argument after a given parameter
# For exemple, after 'm' character there's a colon because 'm' stand for 'manual' but we need to specify the working interface.
# If an argument is required but not provided (i.e, '-m' without specifying an interface) then the script will refer to the colon case (:).
# Meanwhile, 'h' character stands for 'help' and doesn't require any additionnal argument.
do
	case $option in
		m ) # m flag stand for manual
			# Reading Parameter for the new configuration
			read -p "New IP Address (e.g 192.168.0.10) : " ipaddress
			read -p "New Subnet Mask dotted (e.g 255.255.255.0) : " subnetmask
			# Applying the given parameters to the specified interface
			sudo ipconfig set ${OPTARG} MANUAL $ipaddress $subnetmask
			echo "New changes applied"
			exit 0
		;;
		r ) # r flag stand for release
			# After that instruction, the specified interface would have no mode, causing the script to be re-executed with a specified mode.
			sudo ipconfig set ${OPTARG} NONE
			exit 0
		;;
		d ) # d flag stand for DHCP
			echo -e "Setting DHCP mode for the interface ${OPTARG}."
			sudo ipconfig set ${OPTARG} DHCP
			sleep 2
			ipconfig getpacket ${OPTARG}
			exit 0
		;;
		:) # : flag stand for error checking (i.e: parameter requested and no given argument)
			echo "missing argument: -${OPTARG}"
			exit 1
		;;
		h ) # h flag stand for help
			# Calling help function
			help
			exit 0
		;;
		? ) # ? flag stand for any other option
			echo -e "Invalid option: -${OPTARG}"
			help
			exit 1
		;;
	esac
done

if [ "$#" -eq 0 ] # This conditional structure stands if no parameter is given after the script is executed.
then
	echo -e "$(help)\nNo Parameter given"
	exit 1
fi
