#!/bin/sh

if [ ! -f "netbeans/dist/Code_Quality_Checker.jar" ]; then
	cd "$(dirname "$0")"
fi

java -jar "netbeans/dist/Code_Quality_Checker.jar"
