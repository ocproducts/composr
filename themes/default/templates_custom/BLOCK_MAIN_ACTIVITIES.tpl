{$REQUIRE_JAVASCRIPT,activity_feed}
{$SET,is_block_raw,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}

{+START,IF,{$NOT,{$GET,is_block_raw}}}
	{$SET,ajax_block_main_activities_wrapper,ajax_block_main_activities_wrapper_{$RAND%}}
	<div id="{$GET*,ajax_block_main_activities_wrapper}" data-require-javascript="['activities', 'activity_feed']" data-tpl="blockMainActivities" data-tpl-params="{+START,PARAMS_JSON,is_block_raw,MODE,MEMBER_IDS,START,GROW,MAX,REFRESH_TIME}{_*}{+END}">
		<div class="float-surrounder">
			<div id="activities_feed">
				<div id="activities_general_notify"></div>
				<ul class="float-surrounder activities_holder raw_ajax_grow_spot" id="activities_holder">
					{+START,IF_EMPTY,{CONTENT}}
						<li id="activity_-1"><p class="nothing-here">{!NO_ACTIVITIES}</p></li>
					{+END}

					{+START,LOOP,CONTENT}
						<li id="activity_{LIID*}" class="activities_box box">
							{+START,INCLUDE,ACTIVITY}{+END}
						</li>
					{+END}
				</ul>
			</div>

			{+START,IF_NON_EMPTY,{PAGINATION}}
				<div class="pagination-spacing float-surrounder ajax_block_wrapper_links">
					{PAGINATION}
				</div>
			{+END}
		</div>

		{+START,IF_NON_EMPTY,{PAGINATION}}
			{+START,INCLUDE,AJAX_PAGINATION}ALLOW_INFINITE_SCROLL=1{+END}
		{+END}
	</div>
{+END}

{+START,IF,{$GET,is_block_raw}}
	{+START,LOOP,CONTENT}
		<li id="{LIID*}" class="activities_box box">
			{+START,INCLUDE,ACTIVITY}{+END}
		</li>
	{+END}

	{PAGINATION}
{+END}
