<div class="form_group" data-view="ToggleableTray">
	<h2 class="toggleable_tray_title js-tray-header">
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img{+START,IF_PASSED_AND_TRUE,VISIBLE} alt="{!CONTRACT}: {NAME*}" title="{!CONTRACT}"{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE} alt="{!EXPAND}: {NAME*}" title="{!EXPAND}"{+END} src="{+START,IF_PASSED_AND_TRUE,VISIBLE}{$IMG*,1x/trays/contract}{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE}{$IMG*,1x/trays/expand}{+END}" srcset="{+START,IF_PASSED_AND_TRUE,VISIBLE}{$IMG*,2x/trays/contract}{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE}{$IMG*,2x/trays/expand}{+END} 2x" /></a>
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{NAME*}</a>
	</h2>

	<div class="toggleable_tray js-tray-content" id="{ID*}"{+START,IF_NON_PASSED_OR_FALSE,VISIBLE} style="display: none" aria-expanded="false"{+END}>
		<div class="wide_table_wrap"><table class="map_table form_table wide_table">
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
	</div>
</div>

