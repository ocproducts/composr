{$SET,sprite,{$FILE_GET_CONTENTS,{$IMG,icons/sprite}}}
{$SET,icon_id,{$REPLACE,/,__,{NAME}}}
{+START,IF,{$IN_STR,{$GET,sprite},id="{$GET,icon_id}"}}<svg class="icon-svg" role="presentation" {+START,IF_PASSED,SIZE}style="width: {SIZE*}px; height: {SIZE*}px"{+END}><use xlink:href="{$PREG_REPLACE,^https?://[^/]+,,{$IMG,icons/sprite}}#{$GET,icon_id}"/></svg>{+END}
{+START,IF,{$NOT,{$IN_STR,{$GET,sprite},id="{$GET,icon_id}"}}}<img class="icon-img" {+START,IF_PASSED,SIZE}width="{SIZE*}" height="{SIZE*}"{+END} alt="" src="{$IMG*,icons/{NAME}}">{+END}