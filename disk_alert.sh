#!/bin/bash
DISK=$(df -h | grep "/$" | awk '{print $5}' | tr -d "%")
if [ $DISK -gt 80 ]; then
	echo "alert"
else 
	echo "OK"
fi
