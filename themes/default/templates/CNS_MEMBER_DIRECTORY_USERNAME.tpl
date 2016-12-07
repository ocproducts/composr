<span class="vertical_alignment">
	<img data-mouseover-activate-tooltip="['{BOX;^*}','auto']" src="{$THUMBNAIL*,{$?,{$IS_EMPTY,{AVATAR_URL}},{$IMG,cns_default_avatars/default},{AVATAR_URL}},18x18,,,{$IMG,cns_default_avatars/default}}" alt="" />

	<a href="{URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>

	{+START,IF,{$NOT,{VALIDATED}}}
		<span>{!MEMBER_IS_UNVALIDATED}</span>
	{+END}

	{+START,IF,{$NOT,{CONFIRMED}}}
		<span>{!MEMBER_IS_UNCONFIRMED}</span>
	{+END}
</span>
