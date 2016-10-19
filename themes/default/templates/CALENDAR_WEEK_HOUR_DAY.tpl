{+START,IF_NON_EMPTY,{ADD_URL}}
<td data-cms-href="{ADD_URL*}'" class="calendar_{CLASS*}{+START,IF,{CURRENT}} calendar_current{+END}" rowspan="{DOWN*}">
	{ENTRIES}
</td>
{+END}
{+START,IF_EMPTY,{ADD_URL}}
<td class="calendar_{CLASS*}{+START,IF,{CURRENT}} calendar_current{+END}" rowspan="{DOWN*}">
	{ENTRIES}
</td>
{+END}

