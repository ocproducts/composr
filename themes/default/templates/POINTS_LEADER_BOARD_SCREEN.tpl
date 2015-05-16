{TITLE}

<p>
	{!LEADER_BOARD_PAGE_TEXT}
</p>

{WEEKS}

{+START,IF_PASSED,PAGINATION}
	{+START,IF_NON_EMPTY,{PAGINATION}}
		<div class="pagination_spacing float_surrounder">
			{PAGINATION}
		</div>
	{+END}
{+END}
