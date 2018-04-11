{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div class="permissions-matrix-wrap" id="enter-the-matrix" data-tpl="formScreenInputPermissionMatrix" data-tpl-params="{+START,PARAMS_JSON,SERVER_ID}{_*}{+END}">
	<table class="columned-table autosized-table results-table responsive-table">
		<thead>
			<tr>
				<th class="group-header">
					<span class="heading-group">{!USERGROUP}</span> <span class="heading-presets"><span class="inline-mobile"> &amp; </span>{!PINTERFACE_PRESETS}</span>
				</th>

				<th class="view-header">
					<img class="gd-text" data-gd-text="1" src="{$FIND_SCRIPT_NOHTTP*,gd_text}?trans_color={COLOR*}&amp;text={$ESCAPE,{!PINTERFACE_VIEW},UL_ESCAPED}{$KEEP*}" title="{!PINTERFACE_VIEW}" alt="{!PINTERFACE_VIEW}" />
				</th>

				{+START,LOOP,OVERRIDES}
					<th class="privilege-header">
						<img class="gd-text" data-gd-text="1" src="{$FIND_SCRIPT_NOHTTP*,gd_text}?trans_color={COLOR*}&amp;text={$ESCAPE,{TITLE},UL_ESCAPED}{$KEEP*}" title="{TITLE*}" alt="{TITLE*}" />
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
				<td class="form-table-field-name">
					<span class="inline-mobile"><em>{!MASS_PERMISSION_SETTING}</em></span>
				</td>

				<td class="form-table-field-input">
					<button class="button-micro js-click-permissions-toggle" type="button" title="{!MASS_PERMISSION_SETTING}">+/-</button>
				</td>

				{+START,LOOP,OVERRIDES}
					<td class="form-table-field-input">
						<button class="button-micro js-click-permissions-toggle" type="button" title="{!MASS_PERMISSION_SETTING}">+/-</button>
					</td>
				{+END}

				{+START,IF,{$IS_NON_EMPTY,{OVERRIDES}}}
					<td class="form-table-field-input">
					</td>
				{+END}
			</tr>
		</tbody>
	</table>
</div>
