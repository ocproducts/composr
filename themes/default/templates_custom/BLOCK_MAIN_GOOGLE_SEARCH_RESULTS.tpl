<div class="float-surrounder" id="cse">
	{+START,IF_EMPTY,{$_POST,search}}
		<p id="no-search-entered" class="nothing-here">{!NO_SEARCH_ENTERED}</p>
	{+END}

	<gcse:searchresults-only></gcse:searchresults-only>
</div>
