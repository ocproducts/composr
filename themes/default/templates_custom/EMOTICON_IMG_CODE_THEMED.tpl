{$SET,is_in_group,{$IS_IN_GROUP,{$CONFIG_OPTION,jestr_emoticon_magnet_shown_for}}}
{$SET,img_src,{$IMG*,{SRC},1}}
{$SET,rndx,{$RAND}}

{+START,IF,{$NOT,{$IS_IN_GROUP,{$CONFIG_OPTION,jestr_emoticon_magnet_shown_for}}}}
	<img alt="{EMOTICON*}" src="{$IMG*,{SRC},1}" />
{+END}
{+START,IF,{$IS_IN_GROUP,{$CONFIG_OPTION,jestr_emoticon_magnet_shown_for}}}
	{$REQUIRE_JAVASCRIPT,core_rich_media}
	{$REQUIRE_JAVASCRIPT,jestr}
	<div id="emoticoncrazy{$GET%,rndx}" data-tpl="emoticonImgCodeThemedJestr" data-tpl-params="{+START,PARAMS_JSON,is_in_group,img_src,rndx}{_*}{+END}"></div>
{+END}
