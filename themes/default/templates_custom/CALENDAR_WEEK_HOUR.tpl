{$SET,rowspan_detected,{$OR,{$GET,rowspan_detected},{$IN_STR,{DAYS},rowspan="2",rowspan="3",rowspan="4",rowspan="5",rowspan="6",rowspan="7",rowspan="8",rowspan="9",rowspan="10",rowspan="11",rowspan="12",rowspan="13",rowspan="14",rowspan="15",rowspan="16",rowspan="17",rowspan="18",rowspan="19",rowspan="20",rowspan="21",rowspan="22",rowspan="23",rowspan="24"}}}

{+START,IF,{$OR,{$GET,rowspan_detected},{$IN_STR,{DAYS},<img},{$AND,{$GT,{_HOUR},5},{$LT,{_HOUR},25}}}}
	<tr>
		<th class="calendar-week-hour">
			{HOUR*}
		</th>

		{DAYS}
	</tr>
{+END}
