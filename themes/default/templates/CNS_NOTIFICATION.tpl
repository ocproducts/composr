{$REQUIRE_JAVASCRIPT,cns_forum}

<div class="box cns_notification" data-tpl="cnsNotification" data-tpl-params="{+START,PARAMS_JSON,IGNORE_URL_2}{_*}{+END}">
	<div class="box_inner" data-toggleable-tray="{}">
		<p class="cns_notification_intro_line js-tray-onclick-toggle-tray">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {TYPE*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" /></a>

			{!cns:NEW_PT_NOTIFICATION_DETAILS,<span class="cns_notification_type">{TYPE*}</span>,<span class="cns_notification_type_title">{U_TITLE*}</span>,<span class="cns_notification_by">{$?,{$IS_EMPTY,{PROFILE_URL}},{$DISPLAYED_USERNAME*,{BY}},<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{BY}}</a>}</span>,<span class="cns_notification_time">{DATE*}</span>}
		</p>

		<div class="toggleable_tray js-tray-content" style="display: none" aria-expanded="false">
			<div class="cns_notification_post">
				{$TRUNCATE_LEFT,{POST},1000,0,1}
			</div>

			<ul class="horizontal_links associated-links-block-group force_margin">
				<li><span><a href="{TOPIC_URL*}" title="{!VIEW}: {!FORUM_POST} #{ID*}">{!VIEW}</a></span>{+START,IF,{$NEQ,{_ADDITIONAL_POSTS},0}} <img data-cms-rich-tooltip="{}" title="{!cns:ADDITIONAL_PT_POSTS,{ADDITIONAL_POSTS}}" alt="{!HELP}" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" class="top_vertical_alignment help_icon" />{+END}</li>
				<li><a href="{REPLY_URL*}" title="{!REPLY}: {!FORUM_POST} #{ID*}">{!REPLY}</a></li>
				<li><a class="js-click-ignore-notification" data-click-pd="1" href="{IGNORE_URL*}" title="{!MARK_READ}: {!FORUM_POST} #{ID*}">{!IGNORE}</a></li>
			</ul>
		</div>
	</div>
</div>
