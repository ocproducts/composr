{$REQUIRE_JAVASCRIPT,core_notifications}
{$REQUIRE_CSS,notifications}

<div class="block-top-notifications" data-tpl="blockTopNotifications" data-tpl-params="{+START,PARAMS_JSON,MAX}{_*}{+END}">
	<div class="top-button-wrapper js-clickout-hide-top-web-notifications">
		<div class="top-button-popup" id="web-notifications-rel" style="display: none">
			<div class="box box-arrow box--block-top-notifications-web"><span></span><div class="box-inner">
				<div id="web-notifications-spot" role="log">
					{+START,IF_EMPTY,{NOTIFICATIONS}}
						<p class="nothing-here">{!notifications:NO_NOTIFICATIONS}</p>
					{+END}
					{+START,IF_NON_EMPTY,{NOTIFICATIONS}}
						{NOTIFICATIONS}
					{+END}
				</div>

				<ul class="associated-links-block-group horizontal-links">
					<li><a href="{$PAGE_LINK*,_SEARCH:notifications:browse}">{!VIEW_ARCHIVE}</a></li>
					{+START,IF,{$NOT,{$MATCH_KEY_MATCH,_WILD:members:view}}}
						<li><a class="js-click-find-url-tab js-click-toggle-web-notifications" title="{!VIEW_ARCHIVE} {!notifications:NOTIFICATIONS}: {!SETTINGS}" href="{$PAGE_LINK*,{$?,{$CNS},_SEARCH:members:view#tab--edit--notifications,_SEARCH:notifications:overall}}">{!SETTINGS}</a></li>
					{+END}
					<li><a href="#!" class="js-click-notifications-mark-all-read">{!NOTIFICATIONS_MARK_READ}</a></li>
				</ul>
			</div></div>
		</div>

		<a title="{!notifications:NOTIFICATIONS}" id="web-notifications-button" class="top-button count-{NUM_UNREAD_WEB_NOTIFICATIONS%} js-click-toggle-web-notifications" href="{$PAGE_LINK*,_SEARCH:notifications:browse}">
			<span class="top-button-bubble" aria-label="{!COUNT_TOTAL} {!notifications:NOTIFICATIONS}">{NUM_UNREAD_WEB_NOTIFICATIONS*}</span>
			{+START,INCLUDE,ICON}
				NAME=tool_buttons/notifications
				ICON_SIZE=24
			{+END}
		</a>
	</div>
	
	{+START,IF,{$NOT,{$CONFIG_OPTION,pt_notifications_as_web}}}{+START,IF,{$CNS}}
		<div class="top-button-wrapper js-clickout-hide-top-pts">
			<div class="top-button-popup" id="pts-rel" style="display: none">
				<div class="box box-arrow box--block-top-notifications-pts"><span></span><div class="box-inner">
					<div id="pts-spot" role="log">
						{+START,IF_EMPTY,{PTS}}
							<p class="nothing-here">{!cns:NO_INBOX}</p>
						{+END}
						{+START,IF_NON_EMPTY,{PTS}}
							{PTS}
						{+END}
					</div>

					<ul class="associated-links-block-group horizontal-links">
						<li><a class="js-click-find-url-tab js-click-toggle-pts" href="{$PAGE_LINK*,_SEARCH:members:view#tab--pts}">{!cns:PRIVATE_TOPICS_INBOX}</a></li>
						<li><a href="{$PAGE_LINK*,_SEARCH:topics:new_pt}">{!cns:NEW_PRIVATE_TOPIC}</a></li>
					</ul>
				</div></div>
			</div>
			<a title="{!cns:PRIVATE_TOPICS}" id="pts-button" class="top-button count-{NUM_UNREAD_PTS%} js-click-toggle-pts" href="{$PAGE_LINK*,_SEARCH:members:view#tab--pts}">
				<span class="top-button-bubble" aria-label="{!COUNT_TOTAL} {!cns:PRIVATE_TOPICS}">{NUM_UNREAD_PTS*}</span>
				{+START,INCLUDE,ICON}
					NAME=tool_buttons/inbox
					ICON_SIZE=24
				{+END}
			</a>
		</div>
	{+END}{+END}
</div>
