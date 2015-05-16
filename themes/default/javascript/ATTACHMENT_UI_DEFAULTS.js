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
show_overlay=!is_archive;
