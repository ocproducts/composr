{+START,IF_NON_EMPTY,{DAY}}
<td class="calendar_month_day calendar_{CLASS*}{+START,IF,{CURRENT}} calendar_current{+END}" data-cms-href="{DAY_URL*}">
{+END}
{+START,IF_EMPTY,{DAY}}
<td class="calendar_month_day calendar_{CLASS*}{+START,IF,{CURRENT}} calendar_current{+END}">
{+END}

	{+START,IF_NON_EMPTY,{DAY}}
		<div>
			{DAY*}
		</div>
	{+END}
	<div>
		{ENTRIES}
	</div>
</td>
