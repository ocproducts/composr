{$REQUIRE_JAVASCRIPT,chat}
{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_CSS,cns_member_directory}

{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}

{$SET,ajax_block_main_friends_list_wrapper,ajax-block-main-friends-list-wrapper-{$RAND%}}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
<div data-tpl="blockMainFriendsList" data-tpl-params="{+START,PARAMS_JSON,ajax_block_main_friends_list_wrapper,block_call_url}{_*}{+END}">
	<div id="{$GET*,ajax_block_main_friends_list_wrapper}">
		<form target="_self" class="right" role="search" title="{!FRIENDS}, {!SEARCH}" action="{$URL_FOR_GET_FORM*,{$SELF_URL}}#tab--friends" method="get" autocomplete="off">
			{$HIDDENS_FOR_GET_FORM,{$SELF_URL}}

			<label class="accessibility-hidden" for="friends_search">{!SEARCH}</label>
			<input autocomplete="off" maxlength="255" class="js-input-friends-search" type="search" id="friends_search" name="friends_search" value="{$_GET*,friends_search}" />
			<button class="button-micro buttons--filter" type="submit">{+START,INCLUDE,ICON}NAME=buttons/filter{+END} {!FILTER}</button>
		</form>

		<p>{!DESCRIPTION_FRIENDS,{$USERNAME*,{MEMBER_ID},1}}</p>

		{+START,IF_NON_EMPTY,{FRIENDS_FORWARD}}
			<div class="cns-profile-friends block-main-members block-main-members--boxes raw-ajax-grow-spot">
				{+START,LOOP,FRIENDS_FORWARD}
					<div class="box"><div class="box-inner">
						{BOX}
					</div></div>
				{+END}
			</div>

			{+START,IF_NON_EMPTY,{PAGINATION}}
				<div class="pagination-spacing float-surrounder ajax-block-wrapper-links">
					{PAGINATION}
				</div>
			{+END}
		{+END}
		{+START,IF_EMPTY,{FRIENDS_FORWARD}}
			<p class="nothing-here">{!_NO_FRIEND_ENTRIES}</p>
		{+END}

		{+START,IF_NON_EMPTY,{PAGINATION}}
			{+START,INCLUDE,AJAX_PAGINATION}
				WRAPPER_ID={$GET,ajax_block_main_friends_list_wrapper}
				ALLOW_INFINITE_SCROLL=1
			{+END}
		{+END}
	</div>
</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	<div data-tpl="blockMainFriendsList">
		{+START,LOOP,FRIENDS_FORWARD}
			<div class="box"><div class="box-inner">
				{BOX}
			</div></div>
		{+END}

		{PAGINATION}
	</div>
{+END}
