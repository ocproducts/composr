<div class="form_group">
	<h2 class="toggleable_tray_title">
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img{+START,IF_PASSED_AND_TRUE,VISIBLE} alt="{!CONTRACT}: {NAME*}" title="{!CONTRACT}"{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE} alt="{!EXPAND}: {NAME*}" title="{!EXPAND}"{+END} src="{+START,IF_PASSED_AND_TRUE,VISIBLE}{$IMG*,1x/trays/contract}{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE}{$IMG*,1x/trays/expand}{+END}" srcset="{+START,IF_PASSED_AND_TRUE,VISIBLE}{$IMG*,2x/trays/contract}{+END}{+START,IF_NON_PASSED_OR_FALSE,VISIBLE}{$IMG*,2x/trays/expand}{+END} 2x" /></a>
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{NAME*}</a>
	</h2>

	<div class="toggleable_tray" id="{ID*}"{+START,IF_NON_PASSED_OR_FALSE,VISIBLE} style="display: {$JS_ON,none,block}" aria-expanded="false"{+END}>
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

