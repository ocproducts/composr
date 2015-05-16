{+START,IF,{$AND,{$IS_NON_EMPTY,{DAY}},{$JS_ON}}}
<td class="calendar_month_day calendar_{CLASS*}{+START,IF,{CURRENT}} calendar_current{+END}" onkeypress="if (enter_pressed(event)) this.onclick(event);" onclick="window.location.href='{DAY_URL;*}'">
{+END}
{+START,IF,{$NOT,{$AND,{$IS_NON_EMPTY,{DAY}},{$JS_ON}}}}
<td class="calendar_month_day calendar_{CLASS*}{+START,IF,{CURRENT}} calendar_current{+END}">
{+END}

	{+START,IF_NON_EMPTY,{DAY}}
		<div>
			{+START,IF,{$NOT,{$JS_ON}}}
				<a rel="nofollow" href="{DAY_URL*}">{DAY*}</a>
			{+END}
			{+START,IF,{$JS_ON}}
				{DAY*}
			{+END}
		</div>
	{+END}
	<div>
		{ENTRIES}
	</div>
</td>
