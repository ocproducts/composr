<p>
	<input id="poll_vote_button" class="button_micro buttons--vote" type="submit" value="{!VOTE}" />
</p>

<p>
	<span class="associated-link"><a {+START,IF,{$NOT,{$HAS_PRIVILEGE,view_poll_results_before_voting}}} data-cms-confirm-click="{!VOTE_FORFEIGHT*}"{+END} href="{RESULTS_URL*}">{!POLL_RESULTS}</a></span>
</p>
