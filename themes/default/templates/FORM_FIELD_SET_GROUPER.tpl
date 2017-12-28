<div class="form_group" data-toggleable-tray="{}">
	<h2 class="toggleable-tray-title js-tray-header">
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img {+START,IF_PASSED_AND_TRUE,VISIBLE} alt="{!CONTRACT}: {NAME*}" title="{!CONTRACT}"{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE} alt="{!EXPAND}: {NAME*}" title="{!EXPAND}"{+END} src="{+START,IF_PASSED_AND_TRUE,VISIBLE}{$IMG*,1x/trays/contract}{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE}{$IMG*,1x/trays/expand}{+END}" /></a>
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{NAME*}</a>
	</h2>

	<div class="toggleable-tray js-tray-content" id="{ID*}"{+START,IF_NON_PASSED_OR_FALSE,VISIBLE} style="display: none" aria-expanded="false"{+END}>
		<div class="wide-table-wrap"><table class="map_table form-table wide-table">
			{+START,IF,{$DESKTOP}}
				<colgroup>
					<col class="field_name_column" />
					<col class="field_input_column" />
				</colgroup>
			{+END}

			<tbody>
				{FIELDS}
			</tbody>
		</table></div>
	</div>
</div>
