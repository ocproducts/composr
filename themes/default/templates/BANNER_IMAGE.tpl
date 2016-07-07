{$,You may need to remove this or change it to an <a> as shown, if your banner gets placed inside a form, because nested forms are not allowed}
{+START,IF,{$IS_ADMIN}}{+START,IF,{$NOT,{$MATCH_KEY_MATCH,cms:cms_banners}}}
	<form title="{!BANNER}: {!EDIT}{+START,IF_NON_EMPTY,{CAPTION}} ({$STRIP_TAGS,{CAPTION*}}){+END}" class="associated_minor_button_action associated_minor_button_overlayed" method="post" action="{$PAGE_LINK*,cms:cms_banners:_edit:{DEST}}" autocomplete="off"><input title="{!BANNER}: {!EDIT}{+START,IF_NON_EMPTY,{CAPTION}} ({$STRIP_TAGS,{CAPTION*}}){+END}" type="submit" value="{!EDIT}" /></form>
	{$,<a title="{!BANNER}: {!EDIT} ({$STRIP_TAGS,{CAPTION*}})" class="associated_minor_button_action associated_minor_button_overlayed button" href="{$PAGE_LINK*,cms:cms_banners:_edit:{DEST}}">{!EDIT}</a>}
{+END}{+END}

{$,If you dont want most banners to go through the tracking script then this is useful for the href {$?,{$IN_STR,{DEST},_tracked},{$FIND_SCRIPT,banner}?source={SOURCE&}&amp;dest={DEST&}&amp;type=click{$KEEP,0,1},{URL}}}

{+START,IF_NON_EMPTY,{URL}}<a{+START,IF,{$NOT,{$INLINE_STATS}}} onclick="return ga_track(this,'{!BANNER;*}','{DEST;*}');"{+END} rel="nofollow external" title="{!BANNER}{+START,IF_NON_EMPTY,{CAPTION}}: {CAPTION*}{+END} {!LINK_NEW_WINDOW}" class="banner_type_{B_TYPE*} link_exempt"{+START,IF_NON_PASSED_OR_FALSE,LOCAL} target="_blank"{+END} href="{$FIND_SCRIPT*,banner}?source={SOURCE&*}&amp;dest={DEST&*}&amp;type=click{$KEEP*,0,1}">{+END}<img width="{WIDTH*}" height="{HEIGHT*}" alt="{!BANNER}{+START,IF_NON_EMPTY,{CAPTION}}: {CAPTION*}{+END}" style="border: 0" title="{CAPTION*}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{IMG}}" />{+START,IF_NON_EMPTY,{URL}}</a>{+END}
