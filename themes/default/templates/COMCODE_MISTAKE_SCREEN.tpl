{TITLE}

{$REQUIRE_CSS,comcode_mistakes}

<div class="box box___comcode_mistake_screen"><div class="box_inner">
	<h2>{!COMCODE_ERROR_TITLE}</h2>

	<p class="red_alert" role="error">
		{!COMCODE_ERROR,<a href="#errorat" target="_self">{MESSAGE}</a>,{LINE*}}
	</p>

	<div class="float_surrounder">
		<div class="comcode_error_help_div">
			<h2>{!WHAT_IS_COMCODE}</h2>

			{!COMCODE_ERROR_HELP_A}
		</div>

		<div class="comcode_error_details_div">
			{+START,IF,{EDITABLE}}
				{FORM}
			{+END}

			<h2>{!ORIGINAL_COMCODE}</h2>

			<div class="wide_table_wrap"><table class="map_table wide_table results_table autosized_table">
				<tbody>
					{LINES}
				</tbody>
			</table></div>
		</div>
	</div>

	<div>
		<h2>{!REPAIR_HELP}</h2>

		<a id="help"></a>

		{!COMCODE_ERROR_HELP_B}
	</div>
</div></div>


