#!/bin/bash

# Pranav Bhusari
# This script converts certain windows commands to unix commands
# 

COMMAND=$1
ARG1=$2
ARG2=$3

case $COMMAND in 
	author)
		echo "Bhusari Pranav"
		;;
	type)
		cat $ARG1
		;;
	copy)
		cp $ARG1 $ARG2
		;;
	ren|move)
		mv $ARG1 $ARG2
		;;
	del)
		rm $ARG1
		;;
	help)
		echo "Line1"
		echo "Line2"

esac



