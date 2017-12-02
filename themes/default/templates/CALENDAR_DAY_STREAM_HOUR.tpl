{+START,IF_NON_EMPTY,{ADD_URL}}
	<td data-cms-href="{ADD_URL*}" rowspan="{DOWN*}" class="calendar-priority-{PRIORITY*}{+START,IF,{CURRENT}} calendar-current{+END}">
		{ENTRY}
	</td>
{+END}
{+START,IF_EMPTY,{ADD_URL}}
	<td rowspan="{DOWN*}" class="calendar-priority-{PRIORITY*}{+START,IF,{CURRENT}} calendar-current{+END}">
		{ENTRY}
	</td>
{+END}
