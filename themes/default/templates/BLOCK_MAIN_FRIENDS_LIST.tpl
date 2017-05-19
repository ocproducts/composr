{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_CSS,cns_member_directory}

{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{$SET,ajax_block_main_friends_list_wrapper,ajax_block_main_friends_list_wrapper_{$RAND%}}
	<div id="{$GET*,ajax_block_main_friends_list_wrapper}">
		<form target="_self" class="right" role="search" title="{!FRIENDS}, {!SEARCH}" action="{$URL_FOR_GET_FORM*,{$SELF_URL}}#tab__friends" method="get" autocomplete="off">
			{$HIDDENS_FOR_GET_FORM,{$SELF_URL}}

			<label class="accessibility_hidden" for="friends_search">{!SEARCH}</label>
			<input autocomplete="off" maxlength="255" onkeyup="update_ajax_search_list(this,event);" type="search" id="friends_search" name="friends_search" value="{$_GET*,friends_search}" /><input class="button_micro buttons__filter" type="submit" value="{!FILTER}" />
		</form>

		<p>{!DESCRIPTION_FRIENDS,{$USERNAME*,{MEMBER_ID},1}}</p>

		{+START,IF_NON_EMPTY,{FRIENDS_FORWARD}}
			<div class="cns_profile_friends block_main_members block_main_members__boxes raw_ajax_grow_spot">
				{+START,LOOP,FRIENDS_FORWARD}
					<div><div class="box"><div class="box_inner">
						{BOX}
					</div></div></div>
				{+END}
			</div>

			{+START,IF_NON_EMPTY,{PAGINATION}}
				<div class="pagination_spacing float_surrounder ajax_block_wrapper_links">
					{PAGINATION}
				</div>
			{+END}
		{+END}
		{+START,IF_EMPTY,{FRIENDS_FORWARD}}
			<p class="nothing_here">{!_NO_FRIEND_ENTRIES}</p>
		{+END}

		<script>// <![CDATA[
			internalise_ajax_block_wrapper_links('{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}',document.getElementById('{$GET;,ajax_block_main_friends_list_wrapper}'),['.*'],{ },false,true);
		//]]></script>
		{+START,IF_NON_EMPTY,{PAGINATION}}
			{+START,INCLUDE,AJAX_PAGINATION}ALLOW_INFINITE_SCROLL=1{+END}
		{+END}
	</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{+START,LOOP,FRIENDS_FORWARD}
		<div><div class="box"><div class="box_inner">
			{BOX}
		</div></div></div>
	{+END}

	{PAGINATION}
{+END}

