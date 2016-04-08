#!/bin/bash

# NB: This script is not needed if you have suexec

# Clear cache first, as we don't chmod cache files in this code
sh decache.sh

# Reset to good start state first
touch _config.php
find . -type f -not -path "./sites/*" -not -path "./servers/*" -not -path "./_old/*" -not -path "./uploads/*" -exec chmod 644 {} \;
find . -type d -not -path "./sites/*" -not -path "./servers/*" -not -path "./_old/*" -exec chmod 755 {} \;

# Commonly the uploads directory can be missing in git repositories backing up live sites (due to size); but we need it
if [ ! -e "uploads" ]; then
    mkdir uploads
fi

# Change permissions
chmod -f a+w adminzone/pages/comcode_custom/* adminzone/pages/comcode_custom/*/*.txt adminzone/pages/html_custom/* adminzone/pages/html_custom/*/*.htm caches/* caches/lang/* cms/pages/comcode_custom/* cms/pages/comcode_custom/*/*.txt cms/pages/html_custom/* cms/pages/html_custom/*/*.htm collaboration/pages/comcode_custom/* collaboration/pages/comcode_custom/*/*.txt collaboration/pages/html_custom/* collaboration/pages/html_custom/*/*.htm data_custom/errorlog.php data_custom/firewall_rules.txt data_custom/modules/admin_backup data_custom/modules/admin_backup/* data_custom/modules/admin_stats data_custom/modules/admin_stats/* data_custom/modules/chat data_custom/modules/chat/* data_custom/modules/web_notifications data_custom/modules/web_notifications/* data_custom/sitemaps data_custom/sitemaps/* data_custom/spelling/personal_dicts data_custom/spelling/personal_dicts/* data_custom/xml_config data_custom/xml_config/*.xml exports/* exports/*/* forum/pages/comcode_custom/* forum/pages/comcode_custom/*/*.txt forum/pages/html_custom/* forum/pages/html_custom/*/*.htm imports/* imports/*/* lang_custom lang_custom/* lang_custom/*/*.ini pages/comcode_custom/* pages/comcode_custom/*/*.txt pages/html_custom/* pages/html_custom/*/*.htm safe_mode_temp safe_mode_temp/* site/pages/comcode_custom/* site/pages/comcode_custom/*/*.txt site/pages/html_custom/* site/pages/html_custom/*/*.htm text_custom text_custom/* text_custom/*.txt text_custom/*/*.txt themes themes/*/css_custom themes/*/css_custom/* themes/*/images_custom themes/*/images_custom/* themes/*/javascript_custom themes/*/javascript_custom/* themes/*/templates_cached/* themes/*/templates_custom themes/*/templates_custom/* themes/*/text_custom themes/*/text_custom/* themes/*/theme.ini themes/*/xml_custom themes/*/xml_custom/* themes/map.ini uploads/* _config.php 2>/dev/null

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
