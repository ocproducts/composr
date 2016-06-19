{$REQUIRE_JAVASCRIPT,cns_forum}

<a id="poll_jump" rel="dovote"></a>
<form class="cns_topic_poll_form" title="{!VOTE}" action="{VOTE_URL*}" method="post" onsubmit="return cns_check_poll(this,{MINIMUM_SELECTIONS*},{MAXIMUM_SELECTIONS*},({MINIMUM_SELECTIONS*}=={MAXIMUM_SELECTIONS*})?'{!POLL_NOT_ENOUGH_ERROR_2;,{MINIMUM_SELECTIONS*}}':'{!POLL_NOT_ENOUGH_ERROR;,{MINIMUM_SELECTIONS*},{MAXIMUM_SELECTIONS*}}');" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<h3>{+START,FRACTIONAL_EDITABLE,{QUESTION},question,_SEARCH:topics:_edit_poll:{ID}}{QUESTION*}{+END}</h3>

	<div class="wide_table_wrap">
		<table class="spread_table autosized_table cns_topic_poll wide_table">
			<tbody>
				{ANSWERS}
			</tbody>
		</table>

		{+START,IF_NON_EMPTY,{BUTTON}}
			<div class="cns_poll_button">
				{BUTTON}
			</div>
		{+END}

		{+START,IF_NON_EMPTY,{PRIVATE}{NUM_CHOICES}}
			<div class="cns_poll_meta cns_column6">
				{PRIVATE}
				{NUM_CHOICES}
			</div>
		{+END}
	</div>
</form>
