<table class="spread_table calendar_week spaced_table autosized_table columned_table" itemprop="significantLinks">
	<thead>
		<tr>
			<th></th>
			{+START,IF,{$SSW}}
			<th><a href="{SUNDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{SUNDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{SUNDAY_DATE*}}}</a></th>
			{+END}
			<th><a href="{MONDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{MONDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{MONDAY_DATE*}}}</a></th>
			<th><a href="{TUESDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{TUESDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{TUESDAY_DATE*}}}</a></th>
			<th><a href="{WEDNESDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{WEDNESDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{WEDNESDAY_DATE*}}}</a></th>
			<th><a href="{THURSDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{THURSDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{THURSDAY_DATE*}}}</a></th>
			<th><a href="{FRIDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{FRIDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{FRIDAY_DATE*}}}</a></th>
			<th><a href="{SATURDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{SATURDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{SATURDAY_DATE*}}}</a></th>
			{+START,IF,{$NOT,{$SSW}}}
			<th><a href="{SUNDAY_URL*}">{$?,{$MOBILE},{$SUBSTR,{SUNDAY_DATE*},0,1},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{SUNDAY_DATE*}}}</a></th>
			{+END}
		</tr>
	</thead>

	<tbody>
		{HOURS}
	</tbody>
</table>

