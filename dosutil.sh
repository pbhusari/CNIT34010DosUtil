#!/bin/bash

# Pranav Bhusari
# This script converts certain windows commands to unix commands
# November 17th. 2019

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
			verify "$ARG1"
			TYPE=$?
			case $TYPE in
				0)
					if cat "$ARG1"; then
						return 0
					else
						return 1
					fi
					;;
				1)
					echo "This is a directory"
					return 1
					;;
				2)
					echo "File Does Not Exist"
					return 1
					;;
			esac
			;;

		copy)
			verify "$ARG2"
			TYPE=$?
			case $TYPE in
				0)
					echo "Cannot overwrite file: $ARG2"
					return 1
					;;
				1|2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0)
							if cp "$ARG1" "$ARG2"; then 
								return 0
							else
								return 1
							fi	
							;;
						1)
							if cp -r "$ARG1" "$ARG2"; then 
								return 0
							else
								return 1
							fi	
							;;
						2)
														
							echo "File Does not exist"
							return 1
							;;
					esac
					;;
			esac
			;;
		ren)
			verify "$ARG2"
			TYPE=$?
			case $TYPE in
				0|1)
					echo "Name already Exists"
					return 1
					;;
				2)		
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0|1)
							if mv "$ARG1" "$ARG2"; then
								return 0
							else
								return 1
							fi
							;;
						2)
							echo "Source does not exist"
							return 1
							;;
					esac
			esac
			;;
		move)
			verify "$ARG2"
			TYPE=$?
			case $TYPE in 
				0)
					echo "Cannot overwrite file: $ARG2"
					return 1
					;;
				1|2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in 
						0|1)
							if mv "$ARG1" "$ARG2"; then
								return 0
							else
								return 1
							fi
						;;
						2)
							echo "Source does not exist"
							return 1
						;;
					esac
					;;
			
			esac
			;;
            
		del)

			verify "$ARG1"
			TYPE=$?
			case $TYPE in
				0)
					if rm "$ARG1" > /dev/null; then
						return 0
					else
						return 1
					fi
					;;
				1)
					if rm -r "$ARG1" > /dev/null; then
						return 0
					else
						return 1
					fi
					;;
				2)
					echo "File not found!"
					;;

			esac
			;;

		help|*)
			echo "CNIT 34010 - Dosutil Phase 1"
			echo "============================"
			echo "author				output author's name in the form last, first"
			echo "type [FILE]			output the content of the file in the first parameter"
			echo "copy [SOURCE] [DESTINATION]	copy a file"
			echo "ren [FILE] [NEWNAME]		rename a file"
			echo "move [SOURCE] [DESTINATION]	move a file"
			echo "del [FILE]  			delete a file"
			echo "help  				display a list of commands"
	esac	
	
}


command "$1" "$2" "$3"
echo $?



