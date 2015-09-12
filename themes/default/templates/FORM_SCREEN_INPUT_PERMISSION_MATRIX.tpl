<script>// <![CDATA[
	window.perm_serverid='{SERVER_ID;/}';
//]]></script>

<div class="permissions_matrix_wrap" id="enter_the_matrix">
	<table class="columned_table autosized_table results_table">
		<thead>
			<tr>
				<th class="group_header">
					<span class="heading_group">{!USERGROUP}</span> <span class="heading_presets">{!PINTERFACE_PRESETS}</span>
				</th>

				<th class="view_header">
					<img class="gd_text" src="{$BASE_URL*}/data/gd_text.php?trans_color={COLOR*}&amp;text={$ESCAPE,{!PINTERFACE_VIEW},UL_ESCAPED}{$KEEP*}" title="{!PINTERFACE_VIEW}" alt="{!PINTERFACE_VIEW}" />
				</th>

				{+START,LOOP,OVERRIDES}
					<th class="privilege_header">
						<img class="gd_text" src="{$BASE_URL*}/data/gd_text.php?trans_color={COLOR*}&amp;text={$ESCAPE,{TITLE},UL_ESCAPED}{$KEEP*}" title="{TITLE*}" alt="{TITLE*}" />
					</th>
				{+END}

				{+START,IF,{$IS_NON_EMPTY,{OVERRIDES}}}
					{+START,IF,{$JS_ON}}
						<th>
						</th>
					{+END}
				{+END}
			</tr>
		</thead>

		<tbody>
			{PERMISSION_ROWS}

			<tr>
				<td class="form_table_field_name">
				</td>

				<td class="form_table_field_input">
					<input class="button_micro" type="button" value="+/-" onclick="permissions_toggle(this.parentNode);" />
				</td>

				{+START,LOOP,OVERRIDES}
					<td class="form_table_field_input">
						<input class="button_micro" type="button" value="+/-" onclick="permissions_toggle(this.parentNode);" />
					</td>
				{+END}

				{+START,IF,{$IS_NON_EMPTY,{OVERRIDES}}}
					{+START,IF,{$JS_ON}}
						<td class="form_table_field_input">
						</td>
					{+END}
				{+END}
			</tr>
		</tbody>
	</table>
</div>
