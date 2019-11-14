#!/bin/bash

# Pranav Bhusari
# This script converts certain windows commands to unix commands
# 

# 0 --> File
# 1 --> Directory
# 2 --> DNE

verify() {
	
	FILE=$1

	# Test if something is a file
	if test -f "$FILE"; then
		return 0
	fi

	# Test if something is a directory
	if test -d "$FILE"; then
		return 1
	fi

	# Test if something exists or not
	if ! test -f "$FILE"; then
		return 2
	fi

}


command() {

	COMMAND=$1
	ARG1=$2
	ARG2=$3

	case $COMMAND in 
		author)
			echo "Bhusari Pranav"
			;;
		type)
			verify $ARG1
			TYPE=$?
			if [ $TYPE -eq 0 ]; then
				cat $ARG1
			elif [ $TYPE -eq 1 ]; then
				echo "This is a directory"
			else 
				echo "File Does Not Exist"
			fi
			;;
		copy)
			# Do not copy if the ARG1 DNE
			# Do not copy if ARG2 is a file
			# Do not copy if ARG2 is a directory

			verify $ARG1
			TYPE=$?
			if [ $TYPE -eq 0 ]; then
				cat $ARG1
			elif [ $TYPE -eq 1 ]; then
				echo "This is a directory"
			else 
				echo "File Does Not Exist"
			fi
			;;
				
	esac	
	
}


command $1 $2 $3




