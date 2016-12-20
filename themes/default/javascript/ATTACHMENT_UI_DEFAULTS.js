/*
This file is intended for customising the way the attachment UI operates/defaults.

The following variables are defined:
 is_image (boolean)
 is_video (boolean)
 is_audio (boolean)
 is_archive (boolean)
 ext (the file extension, with no dot)
*/

// Add any defaults into URL
defaults.thumb='1';
defaults.type=''; // =autodetect rendering type

// Shall we show the options overlay?
show_overlay=true;
if (multi{+START,IF,{$CONFIG_OPTION,simplified_attachments_ui}} || is_image{+END} || is_archive)
{
	show_overlay=false;
}

{+START,IF,{$CONFIG_OPTION,simplified_attachments_ui}}
	if (is_image && !multi)
	{
		defaults.thumb='0';
	}
{+END}

if (is_image)
{
	tag='attachment_safe';
}

if (multi || is_image)
{
	defaults.framed='0';
}

