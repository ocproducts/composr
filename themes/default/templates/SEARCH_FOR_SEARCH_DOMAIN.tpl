<tr class="search_form_screen_domain">
	<th class="results-table-name search-for-search-domain">{LANG*}</th>

	<td class="form-table-field-input search-for-search-domain-checkbox" colspan="2">
		{+START,IF_NON_EMPTY,{OPTIONS_URL}}
			<span class="search-for-search-domain-more associated-link"><a title="{!ADVANCED}: {$STRIP_TAGS,{LANG*}}" target="_self" href="{OPTIONS_URL*}">{!ADVANCED}</a></span>
		{+END}

		{+START,IF,{$NOT,{ADVANCED_ONLY}}}
			<div class="accessibility-hidden"><label for="search_{NAME*}">{LANG*}</label></div>
			<input type="checkbox" id="search_{NAME*}"{+START,IF,{CHECKED}} checked="checked"{+END} name="search_{NAME*}" value="1" />
		{+END}
	</td>
</tr>
