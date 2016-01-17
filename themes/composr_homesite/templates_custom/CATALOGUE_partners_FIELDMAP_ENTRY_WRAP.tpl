<div class="catalogue_fieldmap_entry_wrap float_surrounder">
	<h3><a title="{FIELD_0_PLAIN*} {!LINK_NEW_WINDOW}" target="_blank" href="{FIELD_3_PLAIN*}">{FIELD_0}</a></h3>

	{+START,IF_NON_EMPTY,{FIELD_2_PLAIN}}
		<img class="right" src="{$THUMBNAIL*,{FIELD_2_PLAIN},160,,,,width}" alt="Logo for {FIELD_0_PLAIN*}" style="padding-left: 10px" />
	{+END}

	<div style="margin-right: 170px">
		<div class="wide_table_wrap"><table class="map_table wide_table results_table spaced_table">
			{+START,IF,{$NOT,{$MOBILE}}}
				<colgroup>
					<col class="catalogue_fieldmap_field_name_column" />
					<col class="catalogue_fieldmap_field_value_column" />
				</colgroup>
			{+END}

			<tbody>
				{FIELDS}

				<tr>
					<th>
						GPS (approximate)
					</th>

					<td>
						{FIELD_6}, {FIELD_7}
					</td>
				</tr>
			</tbody>
		</table></div>

		{+START,IF_PASSED,BREADCRUMBS}
			{+START,IF_NON_EMPTY,{BREADCRUMBS}}
				<nav class="breadcrumbs" itemprop="breadcrumb"><p>{!LOCATED_IN,{BREADCRUMBS}}</p></nav>
			{+END}
		{+END}

		{+START,IF_NON_PASSED_OR_FALSE,ENTRY_SCREEN}
			<div class="float_surrounder">
				{+START,IF,{$NOT,{GIVE_CONTEXT}}}
					<p class="left">
						<a rel="back_to_top" target="_self" href="#"><img class="back_to_top_by_buttons" title="{!BACK_TO_TOP}" alt="{!BACK_TO_TOP}" src="{$IMG*,icons/24x24/tool_buttons/top}" srcset="{$IMG*,icons/48x48/tool_buttons/top} 2x" /></a>
					</p>
				{+END}

				<p class="{$?,{GIVE_CONTEXT},shunted_button,right}">
					<a title="{FIELD_0_PLAIN*} {!LINK_NEW_WINDOW}" target="_blank" class="buttons__more button_screen_item" href="{FIELD_3_PLAIN*}"><span>{!VIEW}</span></a>
				</p>
				{+START,IF_EMPTY,{VIEW_URL}}{+START,IF_NON_EMPTY,{EDIT_URL}}
					<p class="{$?,{GIVE_CONTEXT},shunted_button,right}">
						<a class="buttons__edit button_screen_item" href="{EDIT_URL*}" title="{!EDIT}{+START,IF_PASSED,FIELD_0}: {$STRIP_TAGS*,{FIELD_0}}{+END}"><span>{!EDIT}</span></a>
					</p>
				{+END}{+END}
			</div>
		{+END}
	</div>
</div>
