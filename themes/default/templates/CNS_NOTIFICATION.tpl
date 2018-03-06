{$REQUIRE_JAVASCRIPT,cns_forum}

<div class="box cns-notification" data-tpl="cnsNotification" data-tpl-params="{+START,PARAMS_JSON,IGNORE_URL_2}{_*}{+END}">
	<div class="box-inner" data-toggleable-tray="{}">
		<p class="cns-notification-intro-line js-tray-onclick-toggle-tray">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {TYPE*}" title="{!EXPAND}" width="24" height="24" src="{$IMG*,icons/trays/expand}" /></a>

			{!cns:NEW_PT_NOTIFICATION_DETAILS,<span class="cns-notification-type">{TYPE*}</span>,<span class="cns-notification-type-title">{U_TITLE*}</span>,<span class="cns-notification-by">{$?,{$IS_EMPTY,{PROFILE_URL}},{$DISPLAYED_USERNAME*,{BY}},<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{BY}}</a>}</span>,<span class="cns-notification-time">{DATE*}</span>}
		</p>

		<div class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
			<div class="cns-notification-post">
				{$TRUNCATE_LEFT,{POST},1000,0,1}
			</div>

			<ul class="horizontal-links associated-links-block-group force-margin">
				<li><span><a href="{TOPIC_URL*}" title="{!VIEW}: {!FORUM_POST} #{ID*}">{!VIEW}</a></span>{+START,IF,{$NEQ,{_ADDITIONAL_POSTS},0}} <img data-cms-rich-tooltip="{}" title="{!cns:ADDITIONAL_PT_POSTS,{ADDITIONAL_POSTS}}" alt="{!HELP}" width="24" height="24" src="{$IMG*,icons/help}" class="top-vertical-alignment help-icon" />{+END}</li>
				<li><a href="{REPLY_URL*}" title="{!REPLY}: {!FORUM_POST} #{ID*}">{!REPLY}</a></li>
				<li><a class="js-click-ignore-notification" data-click-pd="1" href="{IGNORE_URL*}" title="{!MARK_READ}: {!FORUM_POST} #{ID*}">{!IGNORE}</a></li>
			</ul>
		</div>
	</div>
</div>
