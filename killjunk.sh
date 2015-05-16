#!/bin/bash

rm -rf _tests install.php install.sql install_ok _config.php.template

# Non-bundled addons
for filename in $(find sources_custom/hooks/systems/addon_registry -name "*.php")
do
	exec<$filename
	while IFS= read line
	do
		if [[ $line == "			'"*"'," ]] && [[ ! $line =~ "=" ]]
		then
			if [[ $line = "themes/default/templates_custom/MAIL.tpl" ]]
			then
				echo
			else
				rm -rf $line
			fi
		fi
	done
done

# Other addon stuff
rm -rf data_custom/addon_screenshots

# Non-EN languages
find . -name "AR" -exec rm -rf {} \; 2> /dev/null
find . -name "BG" -exec rm -rf {} \; 2> /dev/null
find . -name "CS" -exec rm -rf {} \; 2> /dev/null
find . -name "DA" -exec rm -rf {} \; 2> /dev/null
find . -name "DE" -exec rm -rf {} \; 2> /dev/null
find . -name "EL" -exec rm -rf {} \; 2> /dev/null
find . -name "ES" -exec rm -rf {} \; 2> /dev/null
find . -name "FI" -exec rm -rf {} \; 2> /dev/null
find . -name "FR" -exec rm -rf {} \; 2> /dev/null
find . -name "HI" -exec rm -rf {} \; 2> /dev/null
find . -name "HR" -exec rm -rf {} \; 2> /dev/null
find . -name "IT" -exec rm -rf {} \; 2> /dev/null
find . -name "JA" -exec rm -rf {} \; 2> /dev/null
find . -name "KO" -exec rm -rf {} \; 2> /dev/null
find . -name "NL" -exec rm -rf {} \; 2> /dev/null
find . -name "PL" -exec rm -rf {} \; 2> /dev/null
find . -name "PT" -exec rm -rf {} \; 2> /dev/null
find . -name "RO" -exec rm -rf {} \; 2> /dev/null
find . -name "RU" -exec rm -rf {} \; 2> /dev/null
find . -name "SV" -exec rm -rf {} \; 2> /dev/null
find . -name "ZH-CN" -exec rm -rf {} \; 2> /dev/null
find . -name "ZH-TW" -exec rm -rf {} \; 2> /dev/null

# empty dirs
rm -rf buildr data_custom/causes data_custom/jabber-logs data_custom/lolcats data_custom/lolcats/thumbs data_custom/modules/buildr sources_custom/php-crossword sources_custom/programe/aiml sources_custom/programe sources_custom/geshi sources_custom/getid3 uploads/giftr_addon uploads/buildr_addon uploads/diseases_addon uploads/iotds_addon uploads/iotds_thumbs_addon
