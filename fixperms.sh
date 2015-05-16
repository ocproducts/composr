#!/bin/bash

# NB: This script is not needed if you have suexec

# Reset to good start state first
touch _config.php
find . -type f -not -path "./sites/*" -not -path "./servers/*" -not -path "./_old/*" -not -path "./uploads/*" -exec chmod 644 {} \;
find . -type d -not -path "./sites/*" -not -path "./servers/*" -not -path "./_old/*" -exec chmod 755 {} \;

# Commonly the uploads directory can be missing in git repositories backing up live sites (due to size); but we need it
if [ ! -e "uploads" ]; then
    mkdir uploads
fi

# Change permissions
chmod -f a+w caches/*/* caches/*/*/* safe_mode_temp safe_mode_temp/* themes/map.ini data_custom/*.xml data_custom/modules/admin_backup data_custom/modules/web_notifications data_custom/modules/chat data_custom/spelling/personal_dicts data_custom/spelling/personal_dicts/* themes themes/* text_custom/*.txt text_custom/EN/*.txt *_custom *_custom/* *_custom/*/* themes/*/*_custom themes/*/*_custom/* themes/*/templates_cached themes/*/theme.ini themes/*/templates_cached/* themes/*/templates_cached/*/* themes/*/css_custom themes/*/css_custom/*.css themes/*/templates_custom themes/*/templates_custom/*.tpl themes/*/javascript_custom themes/*/javascript_custom/*.tpl themes/*/xml_custom themes/*/xml_custom/*.tpl themes/*/text_custom themes/*/text_custom/*.tpl data_custom/errorlog.php cms_*sitemap.xml data_custom/permissioncheckslog.php data_custom/modules/admin_stats exports/* data_custom/modules/web_notifications/* data_custom/modules/chat/*.dat exports/*/* imports/* imports/*/* uploads/* pages/*_custom pages/*_custom/* pages/*_custom/*/* */pages/*_custom */pages/*_custom/* */pages/*_custom/*/* _config.php 2>/dev/null

# Demonstratr
if [ -z "$1" ]; then
	if [ -e "sites" ]; then
		echo "On Demonstratr"
	else
		find uploads/* -exec chmod a+w {} \;
	fi
fi

# Messages...

if [ -z "$1" ]; then
	echo "Composr file permissions fixed"
fi

if [ $(id -u) = 0 ]; then
	echo "By the way, you are logged in as root or some weird user. Make sure the files aren't owned by root if you want to maintain via FTP. Useful command follows..."
	echo "  find . -user root -exec chown <correctuser> '{}' \;"
fi
