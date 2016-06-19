{TITLE}

{$SET,DEFER_RESULTS_TABLE_PAGINATION,1}

{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

{+START,IF_PASSED,POST_URL}{+START,IF_PASSED,SUBMIT_NAME}
	<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_PASSED,FORM_ID} id="{FORM_ID}"{+END}{+START,IF_NON_PASSED_OR_FALSE,GET} method="post"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get"{+END} action="{POST_URL*}" autocomplete="off">
		{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

		{$SET,DEFER_RESULTS_TABLE_BROWSER,1}
		{TABLE}
		{$SET,DEFER_RESULTS_TABLE_BROWSER,0}

		{+START,IF_PASSED,FIELDS}
			<div class="wide_table_wrap"><table class="map_table wide_table">
				{+START,IF,{$NOT,{$MOBILE}}}
					<colgroup>
						<col class="field_name_column" />
						<col class="field_input_column" />
					</colgroup>
				{+END}

				<tbody>
					{FIELDS}
				</tbody>
			</table></div>
		{+END}

		{+START,IF_PASSED,HIDDEN}
			<div>
				{HIDDEN}
			</div>
		{+END}

		{+START,IF_PASSED,SUBMIT_NAME}
			<p class="proceed_button" id="selection_submit" >
				<input class="{SUBMIT_ICON*} button_screen" type="submit" value="{SUBMIT_NAME*}" />
			</p>
		{+END}
	</form>

	{$GET,RESULTS_TABLE_BROWSER}
{+END}{+END}

{+START,IF_NON_PASSED,SUBMIT_NAME}
	{TABLE}
{+END}

{$GET,RESULTS_TABLE_PAGINATION}

{$SET,DEFER_RESULTS_TABLE_PAGINATION,0}

{+START,IF_PASSED,EXTRA}
	{+START,IF_PASSED,SUB_TITLE}<h2 class="force_margin">{SUB_TITLE*}</h2>{+END}

	{EXTRA}
{+END}

{+START,IF_PASSED,JAVASCRIPT}
	<script>// <![CDATA[
		add_event_listener_abstract(window,"load",function() {
			{JAVASCRIPT/}
		});
	//]]>
	</script>
{+END}
