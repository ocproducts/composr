<div class="text_banner">
	<a rel="external" title="{$STRIP_TAGS,{CAPTION}} {!LINK_NEW_WINDOW}" class="nofollow link_exempt" target="_blank" href="{$FIND_SCRIPT*,banner}?source={SOURCE&*}&amp;dest={DEST&*}&amp;type=click{$KEEP*,0,1}">{TITLE_TEXT*}</a>

	{CAPTION}

	{+START,IF_NON_EMPTY,{FILTERED_URL}}
		<div class="text_banner_l_text">
			{FILTERED_URL*}
		</div>
	{+END}
</div>

