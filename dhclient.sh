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
while getopts ":m:r:w:d:h" option
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
			ipconfig set ${OPTARG} MANUAL $ipaddress $subnetmask
			echo "New changes applied"
			exit 0
		;;
		r ) # r flag stand for release
			# After that instruction, the specified interface would have no mode, causing the script to be re-executed with a specified mode.
			echo -e "Releasing ..."
			ipconfig set ${OPTARG} NONE
			echo "Lease released"
			exit 0
		;;
		w ) # w flag stand for Wi-Fi
			# Enabling or Disabling Wi-Fi
			if [ ${OPTARG} = "on" ]
			then
				echo -e "Enabling Wi-Fi ..."
				networksetup -setairportpower en0 ${OPTARG}
				echo -e "Done !"
				exit 0
			elif [ ${OPTARG} = "off" ]
			then
				echo -e "Disabling Wi-Fi ..."
				networksetup -setairportpower en0 ${OPTARG}
				echo -e "Done !"
				exit 0
			else
				echo -e "Invalid option: -${OPTARG}"
				exit 1
			fi

		;;
		d ) # d flag stand for DHCP
			echo -e "Configuration du mode DHCP pour l'interface ${OPTARG}."
			ipconfig set ${OPTARG} DHCP
			ipconfig waitall
			sleep 4
			echo -e "Nouveau Bail:"
			echo -e "Adresse IP: $(ipconfig getifaddr ${OPTARG})"
			echo -e "Masque de sous-réseau: $(ipconfig getoption ${OPTARG} subnet_mask)"
			echo -e "Passerelle par défaut: $(ipconfig getoption ${OPTARG} router)"
			echo -e "Serveur DHCP: $(ipconfig getoption ${OPTARG} server_identifier)"
			echo -e "Durée du bail DHCP: $(ipconfig getoption ${OPTARG} lease_time) secondes"
			echo -e "Serveur DNS: $(ipconfig getoption ${OPTARG} domain_name_server)"
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
