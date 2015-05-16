{$REQUIRE_JAVASCRIPT,cns_forum}

<div class="cns_topic_poll_form">
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
</div>
