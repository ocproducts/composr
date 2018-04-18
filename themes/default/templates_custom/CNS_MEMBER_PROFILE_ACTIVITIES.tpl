{$REQUIRE_JAVASCRIPT,activity_feed}

<div data-require-javascript="activity_feed" data-tpl="cnsMemberProfileActivities" data-tpl-params="{+START,PARAMS_JSON,SYNDICATIONS}{_*}{+END}">
	<div class="float-surrounder">
		{+START,IF,{$EQ,{MEMBER_ID},{$MEMBER}}}
			{$BLOCK,block=main_activities_state,member={MEMBER_ID},mode=some_members,param=}
		{+END}

		{$BLOCK,block=main_activities,member={MEMBER_ID},mode=some_members,param=,max=10,grow=1}

		<hr class="spaced-rule" />

		<div class="right">
			{+START,INCLUDE,NOTIFICATION_BUTTONS}
				NOTIFICATIONS_TYPE=activity
				NOTIFICATIONS_ID={MEMBER_ID}
			{+END}
		</div>
	</div>

	{+START,IF_NON_EMPTY,{SYNDICATIONS}}
		<p>{!CREATE_SYNDICATION_LINK}</p>

		<form action="{$PAGE_LINK*,_SEARCH:members:view:{MEMBER_ID}}#tab--activities" method="post" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<p>
				{+START,LOOP,SYNDICATIONS}
					{+START,IF,{SYNDICATION_IS_SET}}
						<button class="button-screen-item buttons--cancel" data-disable-on-click="1" type="submit" id="syndicate_stop__{_loop_key*}" name="syndicate_stop__{_loop_key*}">{+START,INCLUDE,ICON}NAME=buttons/cancel{+END} {!STOP_SYNDICATING_TO,{SYNDICATION_SERVICE_NAME*}}</button>
					{+END}
					{+START,IF,{$NOT,{SYNDICATION_IS_SET}}}
						<button class="button-screen-item buttons--proceed" data-disable-on-click="1" type="submit" id="syndicate_start__{_loop_key*}" name="syndicate_start__{_loop_key*}">{!START_SYNDICATING_TO,{SYNDICATION_SERVICE_NAME*}} {+START,INCLUDE,ICON}NAME=buttons/proceed{+END}</button>
					{+END}
				{+END}
			</p>
		</form>
	{+END}
</div>
