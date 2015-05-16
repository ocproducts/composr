#!/bin/bash

echo "Composr: Running..."
sudo hhvm -m server -v "Server.SourceRoot=`pwd`" -v "Server.DefaultDocument=index.php" -v "Log.Level=Verbose" --config "cms.hdf"
