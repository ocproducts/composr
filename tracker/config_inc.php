<?php
/*
To integrate with Composr...

Install Mantis 1.2.0 normally, to the same database as your Composr site
Delete the Mantis files
Fix any TODO's in this file
Upload this

This is a fork of Mantis, security fixes have been applied.
*/

# MantisBT - a php based bugtracking system

# MantisBT is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# MantisBT is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MantisBT.  If not, see <http://www.gnu.org/licenses/>.

/**
 * @package MantisBT
 * @copyright Copyright (C) 2000 - 2002  Kenzaburo Ito - kenito@300baud.org
 * @copyright Copyright (C) 2002 - 2010  MantisBT Team - mantisbt-dev@lists.sourceforge.net
 * @link http://www.mantisbt.org
 */

# This sample file contains the essential files that you MUST
# configure to your specific settings.  You may override settings
# from config_defaults_inc.php by assigning new values in this file

# Rename this file to config_inc.php after configuration.

# In general the value OFF means the feature is disabled and ON means the
# feature is enabled.  Any other cases will have an explanation.

# Look in http://www.mantisbt.org/docs/ or config_defaults_inc.php for more
# detailed comments.

require(dirname(__FILE__).'/../_config.php');

# --- Database Configuration ---
$g_hostname = $SITE_INFO['db_site_host'];
$g_db_username = $SITE_INFO['db_site_user'];
$g_db_password = $SITE_INFO['db_site_password'];
$g_database_name = $SITE_INFO['db_site'];
$g_db_type = $SITE_INFO['db_type'];
$cms_sc_db_prefix = $SITE_INFO['table_prefix'];
$cms_sc_session_cookie_name = $SITE_INFO['session_cookie'];
$cms_sc_multi_lang_content = (!isset($SITE_INFO['multi_lang_content'])) || ($SITE_INFO['multi_lang_content'] == '1');

# --- Anonymous Access / Signup ---
$g_allow_signup = ON;
$g_allow_anonymous_login = ON;
$g_anonymous_account = 'Guest';
$g_lost_password_feature = OFF;

# --- Attachments / File Uploads ---
$g_allow_file_upload = ON;
$g_file_upload_method = DISK; # or DISK
$g_absolute_path_default_upload_folder = dirname(__FILE__).DIRECTORY_SEPARATOR.'uploads'.DIRECTORY_SEPARATOR ; # used with DISK, must contain trailing \ or /.
$g_max_file_size = 25000000; # in bytes
$g_preview_attachments_inline_max_size = 256 * 1024;
$g_allowed_files = '1st,3g2,3gp,3gp2,3gpp,3p,7z,aac,ai,aif,aifc,aiff,asf,avi,bmp,bz2,csv,cur,dat,diff,doc,docx,dot,dotx,eml,f4v,gif,gz,ico,ics,ini,iso,jpe,jpeg,jpg,keynote,log,m2v,m4v,mdb,mid,mov,mp2,mp3,mp4,mpa,mpe,mpeg,mpg,mpv2,numbers,odb,odc,odg,odi,odp,ods,odt,ogg,ogv,otf,pages,patch,pdf,png,ppt,pptx,ps,psd,pub,qt,ra,ram,rar,rm,rtf,sql,tar,tga,tgz,tif,tiff,torrent,tpl,ttf,txt,vsd,vtt,wav,weba,webm,webp,wma,wmv,xls,xlsx,zip';
$g_disallowed_files = ''; # extensions comma separated


# --- Email Configuration ---
$g_phpMailer_method = PHPMAILER_METHOD_MAIL; # or PHPMAILER_METHOD_SMTP, PHPMAILER_METHOD_SENDMAIL
$g_smtp_host = 'localhost'; # used with PHPMAILER_METHOD_SMTP
$g_smtp_username = ''; # used with PHPMAILER_METHOD_SMTP
$g_smtp_password = ''; # used with PHPMAILER_METHOD_SMTP
$g_administrator_email = 'info@compo.sr'; // TODO: Customise
$g_webmaster_email = $g_administrator_email;
$g_from_name = 'Composr CMS feature tracker'; // TODO: Customise
$g_from_email = $g_administrator_email; # the "From: " field in emails
$g_return_path_email = $g_administrator_email; # the return address for bounced mail
$g_email_receive_own = OFF;
$g_email_send_using_cronjob = OFF;

# --- Real names ---
$g_show_realname = OFF;
$g_show_user_realname_threshold = NOBODY; # Set to access level (e.g. VIEWER, REPORTER, DEVELOPER, MANAGER, etc)

# --- Others (Composr-specific) ---
$cms_sc_site_url = $SITE_INFO['base_url'];
$cms_sc_site_name = 'compo.sr';
$g_default_home_page = 'my_view_page.php'; # Set to name of page to go to after login
$g_logo_url = $cms_sc_site_url.'/';
$cms_sc_profile_url = $cms_sc_site_url.'/members/view.htm';
$cms_sc_commercial_support_url = $cms_sc_site_url.'/professional-support.htm';
$cms_sc_report_guidance_url = $cms_sc_site_url.'/docs/tut-software-feedback.htm';
$cms_sc_join_url = $cms_sc_site_url.'/join.htm';
$cms_sc_member_view_url = $cms_sc_site_url.'/members/view/%1$d.htm'; # Set the user id as variable in the url ie %1$d
$cms_sc_sourcecode_link = '<a href="https://github.com/ocproducts/composr">GitHub</a>';
$cms_sc_product_name = 'Composr';
$cms_sc_business_name = 'ocProducts';
$cms_sc_business_name_possesive = 'ocProduct\'s';
$cms_sc_credits_per_hour = 6;
$cms_sc_price_per_credit = 5.5;
$cms_sc_main_currency = 'GBP';
$cms_sc_main_currency_symbol = '&pound';
$cms_sc_alternate_currencies = array('USD', 'CAD', 'EUR');
$cms_sc_custom_profile_field = 'cms_support_credits';
$cms_sponsorship_locked_until = mktime(0, 0, 0, 7, 1, 2016); // Useful to deal with work back-logs, as unscheduled work can be a major problem sometimes (as much as sponsorship is valued and important)

$cms_updater_groups = array();
$cms_developer_groups = array(22);
$cms_manager_groups = array();
$cms_admin_groups = array(2,3);

$g_enable_sponsorship = ON;
$g_sponsorship_currency = $cms_sc_main_currency.' '.$cms_sc_main_currency_symbol;
$g_minimum_sponsorship_amount = $cms_sc_price_per_credit;

$g_source_control_set_status_to = RESOLVED;
$g_source_control_set_resolution_to = FIXED;
$g_source_control_account = 'Chris Graham'; // TODO
$g_source_control_regex = '/\b(?:bug|issue|feature|request)\s*[#]{0,1}(\d+)\b/i';

$g_show_user_email_threshold = ADMINISTRATOR;

$g_cookie_time_length = 60*60*24*30;

# --- Simplify by removing unneeded filter complexity ---

$g_default_refresh_delay = 30;

$g_default_bug_severity = FEATURE;
$g_default_bug_reproducibility = 100;

$g_bug_reopen_status = NEW_;
$g_bug_feedback_status = NEW_;

$g_status_enum_string = '10:non-assigned,50:assigned,80:resolved,90:closed';
$g_status_colors		= array( 'non-assigned'			=> '#fcbdbd', // red    (scarlet red #ef2929)
								 'feedback'		=> '#e3b7eb', // purple (plum        #75507b)
								 'acknowledged'	=> '#ffcd85', // orange (orango      #f57900)
								 'confirmed'	=> '#fff494', // yellow (butter      #fce94f)
								 'assigned'		=> '#c2dfff', // blue   (sky blue    #729fcf)
								 'resolved'		=> '#d2f5b0', // green  (chameleon   #8ae234)
								 'closed'		=> '#c9ccc4'); // grey  (aluminum    #babdb6)

// Lets make it so only website-visitors can post. Otherwise spam happens.
$g_add_bugnote_threshold = isset($_COOKIE[$SITE_INFO['session_cookie']]) ? ANYBODY : REPORTER;
$g_report_bug_threshold = isset($_COOKIE[$SITE_INFO['session_cookie']]) ? ANYBODY : REPORTER;

$g_html_valid_tags = 'p, li, ul, ol, br, pre, i, b, u, em';

# --- Branding ---
$g_window_title = 'Composr CMS feature tracker'; // TODO: Customise
$g_logo_image = '../themes/default/images/EN/logo/standalone_logo.png'; // TODO: Customise
$g_favicon_image = $cms_sc_site_url.'/themes/default/images/favicon.ico';


$g_database_version = 182;
