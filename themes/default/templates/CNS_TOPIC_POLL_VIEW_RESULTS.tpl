{$REQUIRE_JAVASCRIPT,cns_forum}

<div class="cns-topic-poll-form">
	<h3>{+START,FRACTIONAL_EDITABLE,{QUESTION},question,_SEARCH:topics:_edit_poll:{ID}}{QUESTION*}{+END}</h3>

	<div class="wide-table-wrap">
		<table class="spread-table autosized-table cns-topic-poll wide-table">
			<tbody>
				{ANSWERS}
			</tbody>
		</table>

		{+START,IF_NON_EMPTY,{BUTTON}}
			<div class="cns-poll-button">
				{BUTTON}
			</div>
		{+END}

		{+START,IF_NON_EMPTY,{PRIVATE}{NUM_CHOICES}}
			<div class="cns-poll-meta cns-column6">
				{PRIVATE}
				{NUM_CHOICES}
			</div>
		{+END}
	</div>
</div>
