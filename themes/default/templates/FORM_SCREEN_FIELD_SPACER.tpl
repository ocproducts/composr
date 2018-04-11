<!-- form-table-field-spacer (don't remove this comment when templating) -->
<tr class="form-table-field-spacer" data-tpl="formScreenFieldSpacer" data-tpl-params="{+START,PARAMS_JSON,TITLE,SECTION_HIDDEN}{_*}{+END}">
	<th colspan="2" class="table-heading-cell vertical-alignment">
		{+START,IF_PASSED,TITLE}
			{+START,IF_NON_PASSED_OR_FALSE,FORCE_OPEN}
				<a class="toggleable-tray-button js-click-toggle-subord-fields js-keypress-toggle-subord-fields" id="fes{TITLE|}" href="#!"><img class="vertical-alignment right" alt="{!CONTRACT}: {TITLE*}" title="{!CONTRACT}" width="20" height="20" src="{$IMG*,icons/trays/contract}" /></a>
			{+END}

			<span class="faux-h2 {+START,IF_NON_PASSED_OR_FALSE,FORCE_OPEN} toggleable-tray-button js-click-toggle-subord-fields js-keypress-toggle-subord-fields{+END}">{TITLE*}</span>

			{+START,IF,{$EQ,{TITLE},{!ADDRESS}}}
				<button class="button-micro buttons--search js-click-geolocate-address-fields" type="button">{!locations:FIND_ME}</button>
			{+END}
		{+END}

		{+START,IF_PASSED,HELP}{+START,IF_NON_EMPTY,{HELP}}
			<div {+START,IF_PASSED,TITLE} id="fes{TITLE|}-help"{+END}>
				{$PARAGRAPH,{HELP*}}
			</div>
		{+END}{+END}
	</th>
</tr>
