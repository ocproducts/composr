{+START,IF_NON_EMPTY,{ADD_URL}}
<td onkeypress="if (enter_pressed(event)) this.onclick(event);" onclick="window.location.href='{ADD_URL;*}'" rowspan="{DOWN*}" class="calendar_priority_{PRIORITY*}{+START,IF,{CURRENT}} calendar_current{+END}">
	{ENTRY}
</td>
{+END}
{+START,IF_EMPTY,{ADD_URL}}
<td rowspan="{DOWN*}" class="calendar_priority_{PRIORITY*}{+START,IF,{CURRENT}} calendar_current{+END}">
	{ENTRY}
</td>
{+END}

