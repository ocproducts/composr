{$REQUIRE_JAVASCRIPT,core_notifications}
{$REQUIRE_CSS,notifications}

<div data-tpl="blockTopNotifications" data-tpl-params="{+START,PARAMS_JSON,MAX}{_*}{+END}">
	<div class="global_button_ref_point" id="web_notifications_rel" style="display: none">
		<div class="box box-arrow box__block_top_notifications_web"><span></span><div class="box-inner">
			<div id="web_notifications_spot" role="log">
				{+START,IF_EMPTY,{NOTIFICATIONS}}
					<p class="nothing_here">{!notifications:NO_NOTIFICATIONS}</p>
				{+END}
				{+START,IF_NON_EMPTY,{NOTIFICATIONS}}
					{NOTIFICATIONS}
				{+END}
			</div>

			<ul class="associated-links-block-group horizontal-links">
				<li><a href="{$PAGE_LINK*,_SEARCH:notifications:browse}">{!VIEW_ARCHIVE}</a></li>
				{+START,IF,{$NOT,{$MATCH_KEY_MATCH,_WILD:members:view}}}
					<li><a class="js-mouseup-toggle-web-notifications js-mouseup-find-url-tab" title="{!VIEW_ARCHIVE} {!notifications:NOTIFICATIONS}: {!SETTINGS}" href="{$PAGE_LINK*,{$?,{$CNS},_SEARCH:members:view#tab__edit__notifications,_SEARCH:notifications:overall}}">{!SETTINGS}</a></li>
				{+END}
				<li><a href="#!" class="js-click-notifications-mark-all-read">{!NOTIFICATIONS_MARK_READ}</a></li>
			</ul>
		</div></div>
	</div>
	<a title="{!notifications:NOTIFICATIONS}" id="web_notifications_button" class="count_{NUM_UNREAD_WEB_NOTIFICATIONS%} js-click-toggle-web-notifications" href="{$PAGE_LINK*,_SEARCH:notifications:browse}"><span aria-label="{!COUNT_TOTAL} {!notifications:NOTIFICATIONS}">{NUM_UNREAD_WEB_NOTIFICATIONS*}</span></a>

	{+START,IF,{$NOT,{$CONFIG_OPTION,pt_notifications_as_web}}}{+START,IF,{$CNS}}
		<div class="global_button_ref_point" id="pts_rel" style="display: none">
			<div class="box box-arrow box__block_top_notifications_pts"><span></span><div class="box-inner">
				<div id="pts_spot" role="log">
					{+START,IF_EMPTY,{PTS}}
						<p class="nothing_here">{!cns:NO_INBOX}</p>
					{+END}
					{+START,IF_NON_EMPTY,{PTS}}
						{PTS}
					{+END}
				</div>

				<ul class="associated-links-block-group horizontal-links">
					<li><a class="js-mouseup-find-url-tab js-mouseup-toggle-pts" href="{$PAGE_LINK*,_SEARCH:members:view#tab__pts}">{!cns:PRIVATE_TOPICS_INBOX}</a></li>
					<li><a href="{$PAGE_LINK*,_SEARCH:topics:new_pt}">{!cns:NEW_PRIVATE_TOPIC}</a></li>
				</ul>
			</div></div>
		</div>
		<a title="{!cns:PRIVATE_TOPICS}" id="pts_button" class="count_{NUM_UNREAD_PTS%} js-click-toggle-pts" href="{$PAGE_LINK*,_SEARCH:members:view#tab__pts}"><span aria-label="{!COUNT_TOTAL} {!cns:PRIVATE_TOPICS}">{NUM_UNREAD_PTS*}</span></a>
	{+END}{+END}
</div>
