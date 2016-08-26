<!-- form_table_field_spacer (don't remove this comment when templating) -->
<tr class="form_table_field_spacer" data-tpl-core-form-interfaces="formScreenFieldSpacer" data-tpl-args="{+START,PARAMS_JSON,TITLE,SECTION_HIDDEN}{_*}{+END}">
	<th{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="table_heading_cell vertical_alignment">
		{+START,IF_PASSED,TITLE}
			{+START,IF,{$JS_ON}}{+START,IF_NON_PASSED_OR_FALSE,FORCE_OPEN}
				<a class="toggleable_tray_button" id="fes{TITLE|}" onkeypress="return this.onclick.call(this,event);" onclick="toggle_subordinate_fields(this.getElementsByTagName('img')[0],'fes{TITLE|}_help'); return false;" href="#"><img class="vertical_alignment right" alt="{!CONTRACT}: {TITLE*}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract}" srcset="{$IMG*,2x/trays/contract} 2x" /></a>
			{+END}{+END}

			<span class="faux_h2{+START,IF,{$JS_ON}}{+START,IF_NON_PASSED_OR_FALSE,FORCE_OPEN} toggleable_tray_button{+END}{+END}"{+START,IF,{$JS_ON}}{+START,IF_NON_PASSED_OR_FALSE,FORCE_OPEN} onkeypress="return this.onclick.call(this,event);" onclick="toggle_subordinate_fields(this.parentNode.getElementsByTagName('img')[0],'fes{TITLE|}_help'); return false;"{+END}{+END}>{TITLE*}</span>

			{+START,IF,{$EQ,{TITLE},{!ADDRESS}}}
				<input class="button_micro buttons__search" type="button" value="{!locations:FIND_ME}" onclick="geolocate_address_fields(); return false;" />
			{+END}
		{+END}

		{+START,IF_PASSED,HELP}{+START,IF_NON_EMPTY,{HELP}}
			<div{+START,IF_PASSED,TITLE} id="fes{TITLE|}_help"{+END}>
				{$PARAGRAPH,{HELP*}}
			</div>
		{+END}{+END}
	</th>
</tr>

