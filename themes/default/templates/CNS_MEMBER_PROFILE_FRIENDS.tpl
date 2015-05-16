{$BLOCK,block=main_friends_list,member_id={MEMBER_ID},max=12}

{+START,IF_NON_EMPTY,{ADD_FRIEND_URL}{REMOVE_FRIEND_URL}}
	<ul class="horizontal_links associated_links_block_group force_margin">
		{+START,IF_NON_EMPTY,{ADD_FRIEND_URL}}
			<li><a title="{$STRIP_TAGS,{!cns:_ADD_AS_FRIEND,{$USERNAME*,{MEMBER_ID}}}}" href="{ADD_FRIEND_URL*}">{!cns:_ADD_AS_FRIEND,{$USERNAME*,{MEMBER_ID},1}}</a></li>
		{+END}
		{+START,IF_NON_EMPTY,{REMOVE_FRIEND_URL}}
			<li><a title="{$STRIP_TAGS,{!cns:_REMOVE_AS_FRIEND,{$USERNAME*,{MEMBER_ID}}}}" href="{REMOVE_FRIEND_URL*}">{!cns:_REMOVE_AS_FRIEND,{$USERNAME*,{MEMBER_ID},1}}</a></li>
		{+END}
	</ul>
{+END}
