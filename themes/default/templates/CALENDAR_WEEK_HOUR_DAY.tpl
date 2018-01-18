{+START,IF_NON_EMPTY,{ADD_URL}}
	<td data-cms-href="{ADD_URL*}'" class="calendar-{CLASS*}{+START,IF,{CURRENT}} calendar-current{+END}" rowspan="{DOWN*}">
		{ENTRIES}
	</td>
{+END}
{+START,IF_EMPTY,{ADD_URL}}
	<td class="calendar-{CLASS*}{+START,IF,{CURRENT}} calendar-current{+END}" rowspan="{DOWN*}">
		{ENTRIES}
	</td>
{+END}
