<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
	<td>
		{+START,IF_NON_EMPTY,{PICTURE_URL}}<a title="{NAME*} {!LINK_NEW_WINDOW}" target="_blank" data-open-as-overlay="{}" href="{PICTURE_URL*}">{+END}{NAME*}{+START,IF_NON_EMPTY,{PICTURE_URL}}</a>{+END}{AUX*} <span class="associated-details">({COUNT*})</span>
	</td>
	{+START,IF_PASSED,COST}
		<td>
			{!W_COST_POINTS,{COST*}}
		</td>
	{+END}
	<td>
		<form data-mouseover-activate-tooltip="['{DESCRIPTION;~*}','auto',null,null,null,true]" data-focus-activate-tooltip="['{DESCRIPTION;~*}','auto',null,null,null,true]" data-blur-deactivate-tooltip="" class="inline" action="{+START,IF_PASSED,COST}{$PAGE_LINK*,_SELF:_SELF:buy:item={NAME}:member={MEMBER}}{+END}{+START,IF_NON_PASSED,COST}{$PAGE_LINK*,_SELF:_SELF:take:item={NAME}:member={MEMBER}}{+END}" method="post" autocomplete="off"><input class="button-hyperlink" type="submit" value="{ACTION*}" /></form>

		{+START,IF,{EDIT_ACCESS}}<a class="associated-link suggested_link" title="{!EDIT}: {NAME*}" href="{$PAGE_LINK*,_SELF:_SELF:edititemcopy:item={NAME}:member={MEMBER}}">{!EDIT}</a>{+END}

		{+START,IF_PASSED,SELLER}
			{!W_FROM,{SELLER*}}
		{+END}
	</td>
</tr>
