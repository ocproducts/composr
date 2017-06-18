<!-- form_table_field_spacer (don't remove this comment when templating) -->
<tr class="form_table_field_spacer" data-tpl="formScreenFieldSpacer" data-tpl-params="{+START,PARAMS_JSON,TITLE,SECTION_HIDDEN}{_*}{+END}">
	<th{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="table_heading_cell vertical_alignment">
		{+START,IF_PASSED,TITLE}
			{+START,IF_NON_PASSED_OR_FALSE,FORCE_OPEN}
				<a class="toggleable_tray_button js-click-toggle-subord-fields js-keypress-toggle-subord-fields" id="fes{TITLE|}" href="#!"><img class="vertical_alignment right" alt="{!CONTRACT}: {TITLE*}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract}" srcset="{$IMG*,2x/trays/contract} 2x" /></a>
			{+END}

			<span class="faux_h2 {+START,IF_NON_PASSED_OR_FALSE,FORCE_OPEN} toggleable_tray_button js-click-toggle-subord-fields js-keypress-toggle-subord-fields{+END}">{TITLE*}</span>

			{+START,IF,{$EQ,{TITLE},{!ADDRESS}}}
				<input class="button_micro buttons__search js-click-geolocate-address-fields" type="button" value="{!locations:FIND_ME}" />
			{+END}
		{+END}

		{+START,IF_PASSED,HELP}{+START,IF_NON_EMPTY,{HELP}}
			<div{+START,IF_PASSED,TITLE} id="fes{TITLE|}_help"{+END}>
				{$PARAGRAPH,{HELP*}}
			</div>
		{+END}{+END}
	</th>
</tr>
