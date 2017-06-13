<div class="topic_list_topic notification_{$?,{HAS_READ},has_read,has_not_read}">
	{$SET,label,{$?,{$EQ,{BY_POSTER_ID},{$MEMBER}},{!WITH_SIMPLE_LOWER,{$DISPLAYED_USERNAME*,{TO_USERNAME}}},{!BY_SIMPLE_LOWER,{$DISPLAYED_USERNAME*,{BY_USERNAME}}}}}

	<img class="right spaced" src="{$?*,{$IS_EMPTY,{$AVATAR,{WITH_POSTER_ID}}},{$IMG,cns_default_avatars/default},{$ENSURE_PROTOCOL_SUITABILITY*,{$AVATAR,{WITH_POSTER_ID}}}}" title="{$GET,label}" alt="{$GET,label}" />

	<div>
		<a onclick="poll_for_notifications(true,true); return open_link_as_overlay(this);" title="{!POST_PLU,{NUM_POSTS*}}, {TITLE*~}" href="{TOPIC_URL*}">{$TRUNCATE_LEFT,{TITLE},30}</a>, {$GET,label}<br />
		<span class="associated_details">({$?,{HAS_READ},{!notifications:HAS_READ},{!notifications:HAS_NOT_READ}})</span>
	</div>

	{+START,IF_NON_EMPTY,{LAST_POST_BY_USERNAME}}
		<div class="topic_list_meta">
			{!LAST_POST_BY_SIMPLE,<a class="topic_list_by" href="{LAST_POST_BY_POSTER_URL*}">{$DISPLAYED_USERNAME*,{LAST_POST_BY_USERNAME}}</a>} @ <span class="must_show_together">{DATE*}</span>
		</div>
	{+END}
</div>

