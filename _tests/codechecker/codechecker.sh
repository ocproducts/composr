#!/bin/sh

if [ ! -f "netbeans/dist/Code_Quality_Checker.jar" ]; then
	cd _tests/codechecker
fi

java -jar "netbeans/dist/Code_Quality_Checker.jar"
