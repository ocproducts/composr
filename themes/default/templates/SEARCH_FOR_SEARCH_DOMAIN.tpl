<tr>
	<th class="results_table_name search_for_search_domain">{LANG*}</th>
	<td class="form_table_field_input">
		{+START,IF,{$NOT,{ADVANCED_ONLY}}}
			<div class="accessibility_hidden"><label for="search_{NAME*}">{LANG*}</label></div>
			<input type="checkbox" id="search_{NAME*}"{+START,IF,{CHECKED}} checked="checked"{+END} name="search_{NAME*}" value="1" />
		{+END}
	</td>
	<td class="form_table_field_input search_for_search_domain_more">
		{+START,IF_NON_EMPTY,{OPTIONS_URL}}
			<span class="associated_link"><a title="{!ADVANCED}: {$STRIP_TAGS,{LANG*}}" target="_self" href="{OPTIONS_URL*}">{!ADVANCED}</a></span>
		{+END}
	</td>
</tr>

