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
rm -rf data_custom/images/addon_screenshots

# Empty dirs
find . -not \( -path */.git -prune \) -type d -empty
