#!/bin/bash

find . -name "*.css" -or -name "*.php" -or -name "*.tpl" -or -name "*.ini" -or -name "*.sh" -or -name "*.java" -or -name "*.js" -or -name "*.txt" -or -name "*.bat" -or -name "*.config" -or -name "*.htaccess" | grep -v "\(\./data_custom/errorlog.php\|\./data_custom/execute_temp.php\|\./data_custom/latest_activity.txt\|\./data_custom/permission_checks.log\|\./docs/api\|\./docs/composr-api-template\|\./themes/default/templates_cached/EN\|\./data_custom/upload-crop\|\./uploads\|\./_config\.php\|\./sources_custom/browser_detect\.php\|\./sources_custom/facebook\|\./sources_custom/sabredav\|\./sources_custom/Cloudinary\|\./sources_custom/ILess\|\./sources_custom/composr_mobile_sdk/ios/ApnsPHP\|\./sources_custom/geshi\|\./sources_custom/photobucket\|\./_tests/simpletest\|\./data_custom/upload-crop/upload_crop_v1\.2\.php\|\./sources/diff\.php\|\./sources/firephp\.php\|\./sources/jsmin\.php\|\./sources_custom/geshi\.php\|\./sources_custom/getid3\|\./sources_custom/Transliterator\|./sources_custom/aws\|./sources/mail_dkim\.php\|\./sources_custom/programe\|\./sources_custom/spout\|\./sources/lang_stemmer_EN\.php\|\./sources_custom/swift_mailer\|\./sources_custom/twitter\.php\|\./tracker\|\./_old\|\./_tests/html_dump\|\./_tests/cmstest\|\./_tests/screens_tested\|\./_tests/simpletest\|\./caches\|\./exports\|\./imports\|\./data/ckeditor\|\./data_custom/ckeditor\|\./data/ace\|\./nbproject\|\./_tests/codechecker/codechecker\.app\|\./_tests/codechecker/netbeans/nbproject\|\./_tests/codechecker/netbeans/build\|\./_tests/codechecker/netbeans/dist\|\./temp\|\./themes/default/javascript/xsl_mopup\.js\|\./themes/default/javascript/widget_color\.js\|\./themes/default/javascript/widget_date\.js\|\./themes/default/javascript/jwplayer\.js\|\./themes/default/javascript_custom/mediaelement-and-player\.js\|\./themes/default/css_custom/mediaelementplayer\.css\|\./themes/default/javascript/sound\.js\|\./themes/default/javascript_custom/charts\.js\|\./themes/default/javascript/modernizr\.js\|\./themes/default/javascript/select2\.js\|\./themes/default/javascript/plupload\.js\|\./themes/default/javascript_custom/confluence\.js\|\./themes/default/javascript_custom/confluence2\.js\|\./themes/default/javascript_custom/columns\.js\|\./themes/default/javascript_custom/jquery_flip\.js\|\./themes/default/javascript_custom/tag_cloud\.js\|\./themes/default/javascript_custom/base64\.js\|\./mobiquo/smartbanner\|\./mobiquo/lib\|\./data/modules/admin_stats/IP_Country\.txt\|.*/.htaccess\|.*/index\.html\|\./docs\|./themes/default/javascript_custom/skitter.js\|./themes/default/javascript_custom/sortable_tables.js\|./themes/default/javascript_custom/unslider.js\|./themes/default/css_custom/skitter.css\|./themes/default/css_custom/unslider.css\|./themes/default/css_custom/sortable_tables.css\|./themes/default/css_custom/google_search.css\|./themes/default/css_custom/columns.css\|./themes/default/css_custom/flip.css\|./themes/default/css_custom/confluence.css\).*" | xargs wc -l | grep "^\\s\+\\d\+ total$"

# Remember to update .editorconfig and licence.txt and phpdoc.dist.xml and https://docs.google.com/spreadsheets/d/1Im6ICITZmzoBVMizD0CkM7N0kXH5Rb-NQJzD1hk49cU/edit#gid=0 and automated test skipping and maintenance_sheet.csv too (as appropriate).
