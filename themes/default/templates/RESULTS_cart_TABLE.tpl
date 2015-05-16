{+START,IF_EMPTY,{FIELDS}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}
{+START,IF_NON_EMPTY,{FIELDS}}
	{MESSAGE}
	<div class="wide_table_wrap">
		<table class="columned_table wide_table cart_table autosized_table results_table">
			<thead>
				<tr>
					{FIELDS_TITLE}
				</tr>
			</thead>
			<tbody>
				{FIELDS}
			</tbody>
		</table>
	</div>
{+END}
