#!/bin/sh

days=$1
re='^[0-9]+$'
if ! [[ $days =~ $re ]] ; then
	days="10"
fi

echo "Creating $(basename `pwd`)-changes-$(date +%Y%m%d).tar with files from the last $days days"

find * -mtime "-$days" -type f -print0 | xargs -0 tar rvf $(basename `pwd`)-changes-$(date +%Y%m%d).tar --exclude .svn --exclude "*.tar" --exclude "*_cached" --exclude "*_cache"  --exclude _config.php --exclude "*.tmproj" --exclude "*~*" --exclude "Thumbs.db*" --exclude .DS_Store --exclude auto_thumbs --exclude errorlog.php --exclude permissioncheckslog.php --exclude critical_errors --exclude data_custom/latest_activity.txt --exclude uploads/galleries --exclude uploads/galleries_thumbs --exclude uploads/incoming --exclude uploads/auto_*

