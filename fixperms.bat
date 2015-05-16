echo "Trying old style first..."
set user="NT AUTHORITY\NETWORK"
cacls data_custom\modules\chat /e /g %user%:F
cacls data_custom\modules\admin_backup /e /g %user%:F
cacls data_custom\spelling /e /g %user%:F
cacls data_custom\spelling\personal_dicts /e /g %user%:F
cacls themes /e /g %user%:F
cacls text_custom\*.txt /e /g %user%:F
cacls text_custom\EN\*.txt /e /g %user%:F
cacls persistant_cache /e /g %user%:F
cacls persistant_cache\* /e /g %user%:F
cacls safe_mode_temp /e /g %user%:F
cacls safe_mode_temp\* /e /g %user%:F
cacls caches\lang /e /g %user%:F
cacls caches\lang\* /e /g %user%:F
cacls lang_custom /e /g %user%:F
cacls lang_custom\* /e /g %user%:F
cacls lang_custom\*\* /e /g %user%:F
cacls themes\map.ini /e /g %user%:F
cacls themes\default /e /g %user%:F
cacls themes\default\css_custom /e /g %user%:F
cacls themes\default\css_custom\* /e /g %user%:F
cacls themes\default\images_custom /e /g %user%:F
cacls themes\default\images_custom\* /e /g %user%:F
cacls themes\default\templates_custom /e /g %user%:F
cacls themes\default\templates_custom\* /e /g %user%:F
cacls themes\default\javascript_custom /e /g %user%:F
cacls themes\default\javascript_custom\* /e /g %user%:F
cacls themes\default\xml_custom /e /g %user%:F
cacls themes\default\xml_custom\* /e /g %user%:F
cacls themes\default\text_custom /e /g %user%:F
cacls themes\default\text_custom\* /e /g %user%:F
cacls themes\default\theme.ini /e /g %user%:F
cacls themes\default\templates_cached /e /g %user%:F
cacls themes\default\templates_cached\* /e /g %user%:F
cacls themes\admin\css_custom /e /g %user%:F
cacls themes\admin\css_custom\* /e /g %user%:F
cacls themes\admin\images_custom /e /g %user%:F
cacls themes\admin\images_custom\* /e /g %user%:F
cacls themes\admin\templates_custom /e /g %user%:F
cacls themes\admin\templates_custom\* /e /g %user%:F
cacls themes\admin\javascript_custom /e /g %user%:F
cacls themes\admin\javascript_custom\* /e /g %user%:F
cacls themes\admin\xml_custom /e /g %user%:F
cacls themes\admin\xml_custom\* /e /g %user%:F
cacls themes\admin\text_custom /e /g %user%:F
cacls themes\admin\text_custom\* /e /g %user%:F
cacls themes\admin\theme.ini /e /g %user%:F
cacls themes\admin\templates_cached /e /g %user%:F
cacls themes\admin\templates_cached\* /e /g %user%:F
cacls data_custom\errorlog.php /e /g %user%:F
cacls data_custom\cms_sitemap.xml /e /g %user%:F
cacls data_custom\cms_news_sitemap.xml /e /g %user%:F
cacls data_custom\modules\admin_stats /e /g %user%:F
cacls imports\* /e /g %user%:F
cacls imports\addons\* /e /g %user%:F
cacls exports\* /e /g %user%:F
cacls exports\backups\* /e /g %user%:F
cacls exports\file_backups\* /e /g %user%:F
cacls exports\addons\* /e /g %user%:F
cacls uploads\* /e /g %user%:F
cacls uploads\banners\* /e /g %user%:F
cacls uploads\catalogues\* /e /g %user%:F
cacls uploads\downloads\* /e /g %user%:F
cacls uploads\filedump\* /e /g %user%:F
cacls uploads\galleries\* /e /g %user%:F
cacls uploads\galleries_thumbs\* /e /g %user%:F
cacls uploads\attachments\* /e /g %user%:F
cacls uploads\attachments_thumbs\* /e /g %user%:F
cacls uploads\auto_thumbs\* /e /g %user%:F
cacls uploads\cns_photos\* /e /g %user%:F
cacls uploads\cns_photos_thumbs\* /e /g %user%:F
cacls uploads\cns_avatars\* /e /g %user%:F
cacls uploads\cns_cpf_upload\* /e /g %user%:F
cacls uploads\repimages\* /e /g %user%:F
cacls uploads\watermarks\* /e /g %user%:F
cacls pages\comcode_custom /e /g %user%:F
cacls pages\comcode_custom\* /e /g %user%:F
cacls pages\comcode_custom\EN\* /e /g %user%:F
cacls forum\pages\comcode_custom /e /g %user%:F
cacls forum\pages\comcode_custom\* /e /g %user%:F
cacls forum\pages\comcode_custom\EN\* /e /g %user%:F
cacls cms\pages\comcode_custom /e /g %user%:F
cacls cms\pages\comcode_custom\* /e /g %user%:F
cacls cms\pages\comcode_custom\EN\* /e /g %user%:F
cacls docs\pages\comcode_custom /e /g %user%:F
cacls docs\pages\comcode_custom\* /e /g %user%:F
cacls docs\pages\comcode_custom\EN\* /e /g %user%:F
cacls site\pages\comcode_custom /e /g %user%:F
cacls site\pages\comcode_custom\* /e /g %user%:F
cacls site\pages\comcode_custom\EN\* /e /g %user%:F
cacls adminzone\pages\comcode_custom /e /g %user%:F
cacls adminzone\pages\comcode_custom\* /e /g %user%:F
cacls adminzone\pages\comcode_custom\EN\* /e /g %user%:F
cacls collaboration\pages\comcode_custom /e /g %user%:F
cacls collaboration\pages\comcode_custom\* /e /g %user%:F
cacls collaboration\pages\comcode_custom\EN\* /e /g %user%:F
cacls _config.php /e /g %user%:F
cacls pages\html_custom /e /g %user%:F
cacls pages\html_custom\* /e /g %user%:F
cacls pages\html_custom\EN\* /e /g %user%:F
cacls forum\pages\html_custom /e /g %user%:F
cacls forum\pages\html_custom\* /e /g %user%:F
cacls forum\pages\html_custom\EN\* /e /g %user%:F
cacls cms\pages\html_custom /e /g %user%:F
cacls cms\pages\html_custom\* /e /g %user%:F
cacls cms\pages\html_custom\EN\* /e /g %user%:F
cacls docs\pages\html_custom /e /g %user%:F
cacls docs\pages\html_custom\* /e /g %user%:F
cacls docs\pages\html_custom\EN\* /e /g %user%:F
cacls site\pages\html_custom /e /g %user%:F
cacls site\pages\html_custom\* /e /g %user%:F
cacls site\pages\html_custom\EN\* /e /g %user%:F
cacls adminzone\pages\html_custom /e /g %user%:F
cacls adminzone\pages\html_custom\* /e /g %user%:F
cacls adminzone\pages\html_custom\EN\* /e /g %user%:F
cacls collaboration\pages\html_custom /e /g %user%:F
cacls collaboration\pages\html_custom\* /e /g %user%:F
cacls collaboration\pages\html_custom\EN\* /e /g %user%:F
cacls pages\modules_custom /e /g %user%:F
cacls pages\modules_custom\* /e /g %user%:F
cacls forum\pages\modules_custom /e /g %user%:F
cacls forum\pages\modules_custom\* /e /g %user%:F
cacls cms\pages\modules_custom /e /g %user%:F
cacls cms\pages\modules_custom\* /e /g %user%:F
cacls docs\pages\modules_custom /e /g %user%:F
cacls docs\pages\modules_custom\* /e /g %user%:F
cacls site\pages\modules_custom /e /g %user%:F
cacls site\pages\modules_custom\* /e /g %user%:F
cacls adminzone\pages\modules_custom /e /g %user%:F
cacls adminzone\pages\modules_custom\* /e /g %user%:F
cacls collaboration\pages\modules_custom /e /g %user%:F
cacls collaboration\pages\modules_custom\* /e /g %user%:F
cacls pages\minimodules_custom /e /g %user%:F
cacls pages\minimodules_custom\* /e /g %user%:F
cacls forum\pages\minimodules_custom /e /g %user%:F
cacls forum\pages\minimodules_custom\* /e /g %user%:F
cacls cms\pages\minimodules_custom /e /g %user%:F
cacls cms\pages\minimodules_custom\* /e /g %user%:F
cacls docs\pages\minimodules_custom /e /g %user%:F
cacls docs\pages\minimodules_custom\* /e /g %user%:F
cacls site\pages\minimodules_custom /e /g %user%:F
cacls site\pages\minimodules_custom\* /e /g %user%:F
cacls adminzone\pages\minimodules_custom /e /g %user%:F
cacls adminzone\pages\minimodules_custom\* /e /g %user%:F
cacls collaboration\pages\minimodules_custom /e /g %user%:F
cacls collaboration\pages\minimodules_custom\* /e /g %user%:F


echo "Trying new style..."
set user="IUSR"
icacls data_custom\modules\admin_backup /grant %user%:(M)
icacls data_custom\modules\chat /grant %user%:(M)
icacls data_custom\spelling /grant %user%:(M)
icacls data_custom\spelling\personal_dicts /grant %user%:(M)
icacls themes /grant %user%:(M)
icacls text_custom\*.txt /grant %user%:(M)
icacls text_custom\EN\*.txt /grant %user%:(M)
icacls persistant_cache /grant %user%:(M)
icacls persistant_cache\* /grant %user%:(M)
icacls safe_mode_temp /grant %user%:(M)
icacls safe_mode_temp\* /grant %user%:(M)
icacls caches\lang /grant %user%:(M)
icacls caches\lang\* /grant %user%:(M)
icacls lang_custom /grant %user%:(M)
icacls lang_custom\* /grant %user%:(M)
icacls themes\map.ini /grant %user%:(M)
icacls themes\default /grant %user%:(M)
icacls themes\default\css_custom /grant %user%:(M)
icacls themes\default\css_custom\* /grant %user%:(M)
icacls themes\default\images_custom /grant %user%:(M)
icacls themes\default\images_custom\* /grant %user%:(M)
icacls themes\default\templates_custom /grant %user%:(M)
icacls themes\default\templates_custom\* /grant %user%:(M)
icacls themes\default\javascript_custom /grant %user%:(M)
icacls themes\default\javascript_custom\* /grant %user%:(M)
icacls themes\default\xml_custom /grant %user%:(M)
icacls themes\default\xml_custom\* /grant %user%:(M)
icacls themes\default\text_custom /grant %user%:(M)
icacls themes\default\text_custom\* /grant %user%:(M)
icacls themes\default\theme.ini /grant %user%:(M)
icacls themes\default\templates_cached /grant %user%:(M)
icacls themes\default\templates_cached\* /grant %user%:(M)
icacls themes\admin\css_custom /grant %user%:(M)
icacls themes\admin\css_custom\* /grant %user%:(M)
icacls themes\admin\images_custom /grant %user%:(M)
icacls themes\admin\images_custom\* /grant %user%:(M)
icacls themes\admin\templates_custom /grant %user%:(M)
icacls themes\admin\templates_custom\* /grant %user%:(M)
icacls themes\admin\javascript_custom /grant %user%:(M)
icacls themes\admin\javascript_custom\* /grant %user%:(M)
icacls themes\admin\xml_custom /grant %user%:(M)
icacls themes\admin\xml_custom\* /grant %user%:(M)
icacls themes\admin\text_custom /grant %user%:(M)
icacls themes\admin\text_custom\* /grant %user%:(M)
icacls themes\admin\theme.ini /grant %user%:(M)
icacls themes\admin\templates_cached /grant %user%:(M)
icacls themes\admin\templates_cached\* /grant %user%:(M)
icacls data_custom\xml_config /grant %user%:(M)
icacls data_custom\errorlog.php /grant %user%:(M)
icacls cms_sitemap.xml /grant %user%:(M)
icacls data_custom\modules\admin_stats /grant %user%:(M)
icacls imports\* /grant %user%:(M)
icacls imports\addons\* /grant %user%:(M)
icacls exports\* /grant %user%:(M)
icacls exports\backups\* /grant %user%:(M)
icacls exports\file_backups\* /grant %user%:(M)
icacls exports\addons\* /grant %user%:(M)
icacls uploads\* /grant %user%:(M)
icacls uploads\banners\* /grant %user%:(M)
icacls uploads\catalogues\* /grant %user%:(M)
icacls uploads\downloads\* /grant %user%:(M)
icacls uploads\filedump\* /grant %user%:(M)
icacls uploads\galleries\* /grant %user%:(M)
icacls uploads\galleries_thumbs\* /grant %user%:(M)
icacls uploads\attachments\* /grant %user%:(M)
icacls uploads\attachments_thumbs\* /grant %user%:(M)
icacls uploads\auto_thumbs\* /grant %user%:(M)
icacls uploads\cns_photos\* /grant %user%:(M)
icacls uploads\cns_photos_thumbs\* /grant %user%:(M)
icacls uploads\cns_avatars\* /grant %user%:(M)
icacls uploads\cns_cpf_upload\* /grant %user%:(M)
icacls uploads\repimages\* /grant %user%:(M)
icacls uploads\watermarks\* /grant %user%:(M)
icacls pages\comcode_custom /grant %user%:(M)
icacls pages\comcode_custom\* /grant %user%:(M)
icacls pages\comcode_custom\EN\* /grant %user%:(M)
icacls forum\pages\comcode_custom /grant %user%:(M)
icacls forum\pages\comcode_custom\* /grant %user%:(M)
icacls forum\pages\comcode_custom\EN\* /grant %user%:(M)
icacls cms\pages\comcode_custom /grant %user%:(M)
icacls cms\pages\comcode_custom\* /grant %user%:(M)
icacls cms\pages\comcode_custom\EN\* /grant %user%:(M)
icacls docs\pages\comcode_custom /grant %user%:(M)
icacls docs\pages\comcode_custom\* /grant %user%:(M)
icacls docs\pages\comcode_custom\EN\* /grant %user%:(M)
icacls site\pages\comcode_custom /grant %user%:(M)
icacls site\pages\comcode_custom\* /grant %user%:(M)
icacls site\pages\comcode_custom\EN\* /grant %user%:(M)
icacls adminzone\pages\comcode_custom /grant %user%:(M)
icacls adminzone\pages\comcode_custom\* /grant %user%:(M)
icacls adminzone\pages\comcode_custom\EN\* /grant %user%:(M)
icacls collaboration\pages\comcode_custom /grant %user%:(M)
icacls collaboration\pages\comcode_custom\* /grant %user%:(M)
icacls collaboration\pages\comcode_custom\EN\* /grant %user%:(M)
icacls _config.php /grant %user%:(M)
icacls pages\html_custom /grant %user%:(M)
icacls pages\html_custom\* /grant %user%:(M)
icacls pages\html_custom\EN\* /grant %user%:(M)
icacls forum\pages\html_custom /grant %user%:(M)
icacls forum\pages\html_custom\* /grant %user%:(M)
icacls forum\pages\html_custom\EN\* /grant %user%:(M)
icacls cms\pages\html_custom /grant %user%:(M)
icacls cms\pages\html_custom\* /grant %user%:(M)
icacls cms\pages\html_custom\EN\* /grant %user%:(M)
icacls docs\pages\html_custom /grant %user%:(M)
icacls docs\pages\html_custom\* /grant %user%:(M)
icacls docs\pages\html_custom\EN\* /grant %user%:(M)
icacls site\pages\html_custom /grant %user%:(M)
icacls site\pages\html_custom\* /grant %user%:(M)
icacls site\pages\html_custom\EN\* /grant %user%:(M)
icacls adminzone\pages\html_custom /grant %user%:(M)
icacls adminzone\pages\html_custom\* /grant %user%:(M)
icacls adminzone\pages\html_custom\EN\* /grant %user%:(M)
icacls collaboration\pages\html_custom /grant %user%:(M)
icacls collaboration\pages\html_custom\* /grant %user%:(M)
icacls collaboration\pages\html_custom\EN\* /grant %user%:(M)
icacls pages\modules_custom /grant %user%:(M)
icacls pages\modules_custom\* /grant %user%:(M)
icacls forum\pages\modules_custom /grant %user%:(M)
icacls forum\pages\modules_custom\* /grant %user%:(M)
icacls cms\pages\modules_custom /grant %user%:(M)
icacls cms\pages\modules_custom\* /grant %user%:(M)
icacls docs\pages\modules_custom /grant %user%:(M)
icacls docs\pages\modules_custom\* /grant %user%:(M)
icacls site\pages\modules_custom /grant %user%:(M)
icacls site\pages\modules_custom\* /grant %user%:(M)
icacls adminzone\pages\modules_custom /grant %user%:(M)
icacls adminzone\pages\modules_custom\* /grant %user%:(M)
icacls collaboration\pages\modules_custom /grant %user%:(M)
icacls collaboration\pages\modules_custom\* /grant %user%:(M)
icacls pages\minimodules_custom /grant %user%:(M)
icacls pages\minimodules_custom\* /grant %user%:(M)
icacls forum\pages\minimodules_custom /grant %user%:(M)
icacls forum\pages\minimodules_custom\* /grant %user%:(M)
icacls cms\pages\minimodules_custom /grant %user%:(M)
icacls cms\pages\minimodules_custom\* /grant %user%:(M)
icacls docs\pages\minimodules_custom /grant %user%:(M)
icacls docs\pages\minimodules_custom\* /grant %user%:(M)
icacls site\pages\minimodules_custom /grant %user%:(M)
icacls site\pages\minimodules_custom\* /grant %user%:(M)
icacls adminzone\pages\minimodules_custom /grant %user%:(M)
icacls adminzone\pages\minimodules_custom\* /grant %user%:(M)
icacls collaboration\pages\minimodules_custom /grant %user%:(M)
icacls collaboration\pages\minimodules_custom\* /grant %user%:(M)


