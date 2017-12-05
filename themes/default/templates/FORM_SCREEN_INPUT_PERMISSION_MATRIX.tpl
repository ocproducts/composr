{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div class="permissions_matrix_wrap" id="enter_the_matrix" data-tpl="formScreenInputPermissionMatrix" data-tpl-params="{+START,PARAMS_JSON,SERVER_ID}{_*}{+END}">
	<table class="columned_table autosized_table results_table responsive-table">
		<thead>
			<tr>
				<th class="group_header">
					<span class="heading_group">{!USERGROUP}</span> <span class="heading_presets"><span class="inline_mobile"> &amp; </span>{!PINTERFACE_PRESETS}</span>
				</th>

				<th class="view_header">
					<img class="gd_text" data-gd-text="1" src="{$BASE_URL*}/data/gd_text.php?trans_color={COLOR*}&amp;text={$ESCAPE,{!PINTERFACE_VIEW},UL_ESCAPED}{$KEEP*}" title="{!PINTERFACE_VIEW}" alt="{!PINTERFACE_VIEW}" />
				</th>

				{+START,LOOP,OVERRIDES}
					<th class="privilege_header">
						<img class="gd_text" data-gd-text="1" src="{$BASE_URL*}/data/gd_text.php?trans_color={COLOR*}&amp;text={$ESCAPE,{TITLE},UL_ESCAPED}{$KEEP*}" title="{TITLE*}" alt="{TITLE*}" />
					</th>
				{+END}

				{+START,IF,{$IS_NON_EMPTY,{OVERRIDES}}}
					<th></th>
				{+END}
			</tr>
		</thead>

		<tbody>
			{PERMISSION_ROWS}

			{$,Mass-set}
			<tr>
				<td class="form_table_field_name">
					<span class="inline_mobile"><em>{!MASS_PERMISSION_SETTING}</em></span>
				</td>

				<td class="form_table_field_input">
					<input class="button_micro js-click-permissions-toggle" type="button" value="+/-" title="{!MASS_PERMISSION_SETTING}" />
				</td>

				{+START,LOOP,OVERRIDES}
					<td class="form_table_field_input">
						<input class="button_micro js-click-permissions-toggle" type="button" value="+/-" title="{!MASS_PERMISSION_SETTING}" />
					</td>
				{+END}

				{+START,IF,{$IS_NON_EMPTY,{OVERRIDES}}}
					<td class="form_table_field_input">
					</td>
				{+END}
			</tr>
		</tbody>
	</table>
</div>
