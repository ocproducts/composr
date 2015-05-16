#!/bin/sh

javac -d netbeans/build/classes netbeans/src/codequalitychecker/*.java -Xlint:unchecked
jar cfe netbeans/dist/Code_Quality_Checker.jar codequalitychecker.Main -C netbeans/build/classes codequalitychecker
