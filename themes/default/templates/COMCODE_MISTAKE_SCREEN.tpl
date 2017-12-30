{TITLE}

{$REQUIRE_CSS,comcode_mistakes}

<div class="box box___comcode_mistake_screen"><div class="box-inner">
	<h2>{!COMCODE_ERROR_TITLE}</h2>

	<p class="red-alert" role="error">
		{!COMCODE_ERROR,<a href="#errorat" target="_self">{MESSAGE}</a>,{LINE*}}
	</p>

	<div class="float-surrounder">
		<div class="comcode-error-help-div">
			<h2>{!WHAT_IS_COMCODE}</h2>

			{!COMCODE_ERROR_HELP_A}
		</div>

		<div class="comcode-error-details-div">
			{+START,IF,{EDITABLE}}
				{FORM}
			{+END}

			<h2>{!ORIGINAL_COMCODE}</h2>

			<div class="wide-table-wrap"><table class="map_table wide-table results-table autosized-table">
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
