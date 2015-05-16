{TITLE}

<p>
	{!ABOUT_POST_HISTORY}
</p>

{+START,IF_NON_EMPTY,{CONTENT}}
	<div class="wide_table_wrap"><table class="map_table autosized_table results_table wide_table">
		<tbody>
			{CONTENT}
		</tbody>
	</table></div>
{+END}
{+START,IF_EMPTY,{CONTENT}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_NON_EMPTY,{PAGINATION}}
	<div class="float_surrounder pagination_spacing">
		{PAGINATION}
	</div>
{+END}
