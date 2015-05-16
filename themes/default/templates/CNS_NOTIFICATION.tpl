{$REQUIRE_JAVASCRIPT,cns_forum}
{$REQUIRE_JAVASCRIPT,ajax}

<div class="box cns_notification"><div class="box_inner">
	<p onclick="/*Access-note: code has other activation*/ return toggleable_tray(this.parentNode,false);" class="cns_notification_intro_line">
		<a class="toggleable_tray_button" href="#" onclick="return false;"><img alt="{!EXPAND}: {TYPE*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>

		{!cns:NEW_PT_NOTIFICATION_DETAILS,<span class="cns_notification_type">{TYPE*}</span>,<span class="cns_notification_type_title">{U_TITLE*}</span>,<span class="cns_notification_by">{$?,{$IS_EMPTY,{PROFILE_URL}},{$DISPLAYED_USERNAME*,{BY}},<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{BY}}</a>}</span>,<span class="cns_notification_time">{TIME*}</span>}
	</p>

	<div class="toggleable_tray" style="display: none" aria-expanded="false">
		<div class="cns_notification_post">
			{$TRUNCATE_LEFT,{POST},1000,0,1}
		</div>

		<ul class="horizontal_links associated_links_block_group force_margin">
			<li><span><a href="{TOPIC_URL*}" title="{!VIEW}: {!FORUM_POST} #{ID*}">{!VIEW}</a></span>{+START,IF,{$NEQ,{_ADDITIONAL_POSTS},0}} <img onclick="this.onmouseover(event);" title="{!cns:ADDITIONAL_PT_POSTS,{ADDITIONAL_POSTS}}" onmouseover="activate_rich_semantic_tooltip(this,event);" alt="{!HELP}" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" class="activate_rich_semantic_tooltip top_vertical_alignment help_icon" />{+END}</li>
			<li><a href="{REPLY_URL*}" title="{!REPLY}: {!FORUM_POST} #{ID*}">{!REPLY}</a></li>
			<li><a onclick="return ignore_cns_notification('{IGNORE_URL_2;*}',this);" href="{IGNORE_URL*}" title="{!MARK_READ}: {!FORUM_POST} #{ID*}">{!IGNORE}</a></li>
		</ul>
	</div>
</div></div>

