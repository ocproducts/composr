<p>
	<input id="poll_vote_button" class="button_micro buttons__vote" type="submit" value="{!VOTE}" />
</p>

<p>
	<span class="associated_link"><a{+START,IF,{$NOT,{$HAS_PRIVILEGE,view_poll_results_before_voting}}} onclick="var t=this; window.fauxmodal_confirm('{!VOTE_FORFEIGHT}',function(result) { if (result) { click_link(t); } }); return false;"{+END} href="{RESULTS_URL*}">{!POLL_RESULTS}</a></span>
</p>

