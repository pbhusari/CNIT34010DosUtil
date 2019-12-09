#!/bin/bash

# Pranav Bhusari
# This script converts certain windows commands to unix commands
# November 17th. 2019

# Variables:

# Global:
# -------
# USERARG1 		--> The first argument that the user is inputting
# USERARG2 		--> The second argument that the user is inputting
# SUCCSESSFUL	--> Stores if a command was succsessful or not

# Verify:
# -------
# FILE 			--> file that the verification funciton is acting on

# Command:
# --------
# COMMAND 		--> Command that the function is acting on
# ARG1 			--> First argument that the function is acting on
# ARG2 			--> Second argument that the function is acting on
# TYPE 			--> Stores the type of the file to be used in case statments

# "File verification function"
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

	# 0 --> File
	# 1 --> Directory
	# 2 --> DNE

}

# "UNIX command execution function"
command() {

	COMMAND=$(echo "$1" | awk '{print tolower($0)}')
	ARG1=$2
	ARG2=$3

	# "A case statement is required"
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
          echo "$ARG1 is a Directory"
					if echo "$(ls -l $ARG1)"; then
					    return 0
          else
              return 1
          fi
					;;
				2)
					echo "ERROR: $ARG1 Does Not Exist"
					return 1
					;;
			esac
			;;
		copy)
			verify "$ARG2"
			TYPE=$?
			case $TYPE in
				0)
					# "Build in handling for file/directory overwrites"
					echo "ERROR: Cannot overwrite file: $ARG2"
					return 1
					;;
				1|2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0)
							if cp "$ARG1" "$ARG2" > /dev/null; then
								return 0
							else
								return 1
							fi
							;;
						1)
							if cp -r "$ARG1" "$ARG2" > /dev/null; then
								return 0
							else
								return 1
							fi
							;;
						2)

							echo "ERROR: $ARG1 Does not exist"
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
					echo "ERROR: $ARG2 already Exists"
					return 1
					;;
				2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0|1)
							if mv "$ARG1" "$ARG2" > /dev/null; then
								return 0
							else
								return 1
							fi
							;;
						2)
							echo "ERROR: $ARG1 does not exist"
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
					# "Build in handling for file/directory overwrites"
					echo "ERROR: Cannot overwrite file: $ARG2"
					return 1
					;;
				1|2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0|1)
							if mv "$ARG1" "$ARG2" > /dev/null; then
								return 0
							else
								return 1
							fi
						;;
						2)
							echo "ERROR: $ARG1 does not exist"
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
					echo "ERROR: $ARG1 does not exist"
					;;

			esac
			;;

		copy!)
			verify "$ARG2"
			TYPE=$?
			case $TYPE in
				0|1|2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0)
							if cp -f "$ARG1" "$ARG2" > /dev/null; then
								return 0
							else
								return 1
							fi
					 		;;
						1)
							rm -r "$ARG2";
							cp -rf "$ARG1" "$ARG2";
							return 0;
							;;
						2)

							echo "ERROR: $ARG1 Does not exist"
							return 1
							;;
				esac
				;;
			esac
			;;
		ren!)
			verify "$ARG2"
			TYPE=$?
			case $TYPE in
				0|1|2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0|1)
							if mv -f "$ARG1" "$ARG2" > /dev/null; then
								return 0
							else
								return 1
							fi
							;;
						2)
							echo "ERROR: $ARG1 does not exist"
							return 1
							;;
					esac
			esac
			;;

		move!)
			verify "$ARG2"
			TYPE=$?
			case $TYPE in
				0|1|2)
					verify "$ARG1"
					TYPE=$?
					case $TYPE in
						0|1)
							if mv "$ARG1" "$ARG2" > /dev/null; then
								return 0
							else
								return 1
							fi
						;;
						2)
							echo "ERROR: $ARG1 does not exist"
							return 1
						;;
					esac
					;;

			esac
			;;

		whereami)
      pwd
      ;;

    cd)
      verify "$ARG1"
			TYPE=$?
			case $TYPE in
				0)
					echo "ERROR: $ARG1 is a file"
					;;
				1)
					if cd "$ARG1"; then
							return 0
					else
						return 1
					fi
					;;
				2)
					echo "ERROR: $ARG1 does  not exist"
					;;
				esac
				;;

		exit)
			echo "Program Exited"
			;;
    help|*)
			echo "CNIT 34010 - Dosutil Phase 1"
			echo "============================"
			echo "author				output author's name in the form last first"
			echo "type [[ FILE]			output the content of the file in the first parameter"
			echo "copy [SOURCE] [DESTINATION]	copy a file"
			echo "ren [FILE] [NEWNAME]		rename a file"
			echo "move [SOURCE] [DESTINATION]	move a file"
			echo "del [FILE]  			delete a file"
			echo "help  					display a list of commands"
			echo "copy! [SOURCE] [DESTINATION] force copy a file"
			echo "ren! [SOURCE] [DESTINATION] force rename a file"
			echo "move! [SOURCE] [DESTINATION] force move a file"
      ;;


	esac

}

# "All parameters must be copied into descriptive variable names"

if ! test -z $1 ; then
	COMMAND=$(echo "$1" | awk '{print tolower($0)}')
	USERARG1=$2
	USERARG2=$3

	command "$COMMAND" "$USERARG1" "$USERARG2"

	if [ "$?" != "1" ]; then
		echo "Command executed succsessfully"
	else
		echo "Command executed with errors"
	fi
else
	select COMMAND in type copy ren del move help copy! move! ren! whereami cd sort author exit sort
	do
			# Commands that require 1+ args
			if 	[[ $COMMAND = "type" ]] || [[ $COMMAND == "copy" ]] || [[ $COMMAND == "ren" ]] || [[ $COMMAND == "del" ]] ||  [[ $COMMAND == "move" ]] || [[ $COMMAND == "copy!" ]] || [[ $COMMAND == "move!" ]] || [[ $COMMAND == "ren!" ]] ||  [[ $COMMAND == "cd" ]]; then
					select USERARG1 in $(ls)
					do
						if [[ $COMMAND == "ren" ]] || [[ $COMMAND == "copy" ]] || [[ $COMMAND == "move" ]] || [[ $COMMAND == "copy!" ]] || [[ $COMMAND == "move!" ]] || [[ $COMMAND == "ren!" ]]; then
							read USERARG2
						fi
						break
					done
			fi

			if [[ $COMMAND == "exit" ]]; then
				exit 0
			fi

			command "$COMMAND" "$USERARG1" "$USERARG2"
			SUCCSESSFUL=$?
			# The verification for command ssuccses of the COMMAND funciton is the return value
			# This enables further expandability with other shell scipts
			if [ "$SUCCSESSFUL" != "1" ]; then
				echo "Command executed succsessfully"
			else
				echo "Command executed with errors"
			fi

	done
fi

exec bash
