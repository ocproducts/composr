<table class="spread_table calendar_week spaced_table autosized_table columned_table" itemprop="significantLinks">
	<thead>
		<tr>
			<th></th>
			{+START,IF,{$SSW}}
			<th><a href="{SUNDAY_URL*}">{$?,{$MOBILE},{!FC_SUNDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{SUNDAY_DATE*}}}</a></th>
			{+END}
			<th><a href="{MONDAY_URL*}">{$?,{$MOBILE},{!FC_MONDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{MONDAY_DATE*}}}</a></th>
			<th><a href="{TUESDAY_URL*}">{$?,{$MOBILE},{!FC_TUESDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{TUESDAY_DATE*}}}</a></th>
			<th><a href="{WEDNESDAY_URL*}">{$?,{$MOBILE},{!FC_WEDNESDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{WEDNESDAY_DATE*}}}</a></th>
			<th><a href="{THURSDAY_URL*}">{$?,{$MOBILE},{!FC_THURSDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{THURSDAY_DATE*}}}</a></th>
			<th><a href="{FRIDAY_URL*}">{$?,{$MOBILE},{!FC_FRIDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{FRIDAY_DATE*}}}</a></th>
			<th><a href="{SATURDAY_URL*}">{$?,{$MOBILE},{!FC_SATURDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{SATURDAY_DATE*}}}</a></th>
			{+START,IF,{$NOT,{$SSW}}}
			<th><a href="{SUNDAY_URL*}">{$?,{$MOBILE},{!FC_SUNDAY},{$PREG_REPLACE,^(\w\{3\})\w* ,$1 ,{SUNDAY_DATE*}}}</a></th>
			{+END}
		</tr>
	</thead>

	<tbody>
		{HOURS}
	</tbody>
</table>

