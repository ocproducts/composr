{$REQUIRE_JAVASCRIPT,core_rich_media}

<div data-tpl="comcodeMemberLink" data-tpl-params="{+START,PARAMS_JSON,MEMBER_ID}{_*}{+END}">
	{+START,IF,{$NOT,{$TAPATALK}}}
	<span class="comcode_member_link js-mouseover-comcode-member-link js-focus-comcode-member-link js-mouseout-comcode-member-link" data-blur-deactivate-tooltip>
		<img class="embedded_mini_avatar" src="{$?*,{$IS_EMPTY,{$AVATAR,{MEMBER_ID}}},{$IMG,cns_default_avatars/default},{$ENSURE_PROTOCOL_SUITABILITY*,{$AVATAR,{MEMBER_ID}}}}" alt="" />
		<a href="{MEMBER_URL*}">{USERNAME*}</a>
	</span>
	{+END}
	{+START,IF,{$TAPATALK}}
		<a href="{MEMBER_URL*}">{USERNAME*}</a>
	{+END}
</div>