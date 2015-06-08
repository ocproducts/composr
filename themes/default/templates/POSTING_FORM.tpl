{+START,IF,{$IN_STR,{SPECIALISATION}{SPECIALISATION2},_required}}
	{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
{+END}

<form title="{!PRIMARY_PAGE_FORM}" id="posting_form" method="post" enctype="multipart/form-data" action="{URL*}">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		<div class="wide_table_wrap"><table class="map_table form_table wide_table">
			{+START,IF,{$NOT,{$MOBILE}}}
				<colgroup>
					<col class="field_name_column" />
					<col class="field_input_column" />
				</colgroup>
			{+END}

			<tbody>
				{SPECIALISATION}

				{+START,INCLUDE,POSTING_FIELD}
					NAME=post
					DESCRIPTION=
					WORD_COUNTER=1
				{+END}

				{+START,IF,{$AND,{$IS_NON_EMPTY,{SPECIALISATION2}},{$OR,{$NOT,{$IN_STR,{SPECIALISATION2},<th colspan="2"}},{$LT,{$STRPOS,{SPECIALISATION2},<td},{$STRPOS,{SPECIALISATION2},<th colspan="2"}}}}}
					<tr class="form_table_field_spacer">
						<th{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="table_heading_cell">
							{+START,IF,{$JS_ON}}
								<a class="toggleable_tray_button" onclick="toggle_subordinate_fields(this.getElementsByTagName('img')[0]); return false;" href="#"><img alt="{!CONTRACT}: {!OTHER_DETAILS}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract}" srcset="{$IMG*,2x/trays/contract} 2x" /></a>
							{+END}

							<span class="faux_h2{+START,IF,{$JS_ON}} toggleable_tray_button{+END}"{+START,IF,{$JS_ON}} onclick="/*Access-note: code has other activation*/ toggle_subordinate_fields(this.parentNode.getElementsByTagName('img')[0]); return false;"{+END}>{!OTHER_DETAILS}</span>
						</th>
					</tr>
				{+END}

				{SPECIALISATION2}
			</tbody>
		</table></div>

		{+START,INCLUDE,FORM_STANDARD_END}
			FORM_NAME=posting_form
			SUPPORT_AUTOSAVE={SUPPORT_AUTOSAVE}
			EXTRA_BUTTONS={$GET,extra_buttons}
		{+END}

		<input type="hidden" name="comcode__post" value="1" />
		<input type="hidden" name="posting_ref_id" value="{$RAND,1,2147483646}" />
	</div>
</form>

{+START,IF_PASSED,EXTRA}
	{EXTRA}
{+END}
