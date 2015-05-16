<h2>
	{SECTION*}
</h2>

{+START,IF_NON_EMPTY,{NOTES}}
	<p>
		<em>{NOTES*}</em>
	</p>
{+END}

<div class="wide_table_wrap"><table class="map_table autosized_table centered_table_contents results_table wide_table"><tbody>
	{TESTS}
</tbody></table></div>

{+START,IF_NON_EMPTY,{EDIT_TEST_SECTION_URL}}
	<ul class="actions_list force_margin">
		<li><a href="{EDIT_TEST_SECTION_URL*}" title="{!EDIT_TEST_SECTION}: #{ID*}">{!EDIT_TEST_SECTION}</a></li>
	</ul>
{+END}

<div>
	<hr />
</div>
