<div class="topic_list_topic notification_{$?,{HAS_READ},has_read,has_not_read}">
	<img class="right spaced" src="{$?*,{$IS_EMPTY,{$AVATAR,{WITH_POSTER_ID}}},{$IMG,cns_default_avatars/default},{$ENSURE_PROTOCOL_SUITABILITY*,{$AVATAR,{WITH_POSTER_ID}}}}" title="{!WITH_SIMPLE,{$DISPLAYED_USERNAME*,{WITH_USERNAME}}}" alt="{!WITH_SIMPLE,{$DISPLAYED_USERNAME*,{WITH_USERNAME}}}" />

	<div class="topic_list_title">
		<a onclick="poll_for_notifications(true,true); return open_link_as_overlay(this);" title="{!POST_PLU,{NUM_POSTS*}}, {TITLE*~}" href="{TOPIC_URL*}">{$TRUNCATE_LEFT,{TITLE},30}</a><br />
		<span class="associated_details">({$?,{HAS_READ},{!notifications:HAS_READ},{!notifications:HAS_NOT_READ}})</span>
	</div>

	{+START,IF_NON_EMPTY,{LAST_POST_BY_USERNAME}}
		<div class="topic_list_meta">
			{!LAST_POST_BY_SIMPLE,<a class="topic_list_by" href="{LAST_POST_BY_POSTER_URL*}">{$DISPLAYED_USERNAME*,{LAST_POST_BY_USERNAME}}</a>} @ {DATE*}
		</div>
	{+END}
</div>

