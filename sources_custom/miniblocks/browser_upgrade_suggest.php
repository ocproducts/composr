<?php

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

$ie_needed = array_key_exists('ie_needed', $map) ? floatval($map['ie_needed']) : 7.0; // Latest at time of writing is 8.0. Suggest 6.0 or 7.0 as often people have no choice about upgrading (if they are on corporate PC's, if they pirated Windows (!), or if they are on an old version of Windows
$firefox_needed = array_key_exists('firefox_needed', $map) ? floatval($map['firefox_needed']) : 8.0;
$safari_needed = array_key_exists('safari_needed', $map) ? floatval($map['safari_needed']) : 5.0;
$chrome_needed = array_key_exists('chrome_needed', $map) ? floatval($map['chrome_needed']) : 15.0;
$opera_needed = array_key_exists('firefox_needed', $map) ? floatval($map['firefox_needed']) : 11.0;

$attach = (array_key_exists('attach', $map)) && ($map['attach'] == '1');

require_code('browser_detect');
require_lang('browser_upgrade_suggest');

$message = '';

$browser = new Browser();
if (($browser->getBrowser() == Browser::BROWSER_FIREFOX) && (floatval($browser->getVersion()) < $firefox_needed)) {
    if ($browser->getPlatform() == Browser::PLATFORM_LINUX) {
        $message = do_lang('UPGRADE_FIREFOX_LINUX');
    } else {
        $message = do_lang('UPGRADE_FIREFOX');
    }
}
if (($browser->getBrowser() == Browser::BROWSER_SAFARI) && (floatval($browser->getVersion()) < $safari_needed)) {
    if ($browser->getPlatform() == Browser::PLATFORM_APPLE) {
        $message = do_lang('UPGRADE_SAFARI_MAC');
    } else {
        $message = do_lang('UPGRADE_SAFARI');
    }
}
if (($browser->getBrowser() == Browser::BROWSER_CHROME) && (floatval($browser->getVersion()) < $chrome_needed)) {
    if ($browser->getPlatform() == Browser::PLATFORM_LINUX) {
        $message = do_lang('UPGRADE_CHROME_LINUX');
    } else {
        $message = do_lang('UPGRADE_CHROME');
    }
}
if (($browser->getBrowser() == Browser::BROWSER_IE) && (floatval($browser->getVersion()) < $ie_needed)) {
    switch ($browser->getVersion()) {
        case 8.0:
            $year = '2009';
            break;
        case 7.0:
            $year = '2007';
            break;
        case 6.0:
            $year = '2001';
            break;
        default:
            $year = 'pre-2001';
            break;
    }
    $message = do_lang('UPGRADE_IE', escape_html($year));
}
if (($browser->getBrowser() == Browser::BROWSER_OPERA) && (floatval($browser->getVersion()) < $opera_needed)) {
    $message = do_lang('UPGRADE_OPERA');
}

if ($message != '') {
    if ($attach) {
        attach_message(make_string_tempcode($message), 'warn');
    } else {
        $out = put_in_standard_box(make_string_tempcode($message));
        $out->evaluate_echo();
    }
}
