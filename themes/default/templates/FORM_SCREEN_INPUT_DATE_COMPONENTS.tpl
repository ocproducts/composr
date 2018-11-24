{+START,IF,{WANT_YEAR}}
	<span class="vertical-alignment">
		<label for="{NAME*}_year" class="accessibility-hidden">{PRETTY_NAME*} {!YEAR}</label>
		<select id="{NAME*}_year" name="{NAME*}_year"{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} class="form-control input-date{$?,{REQUIRED},-required}">
			{+START,IF,{$NOT,{REQUIRED}}}
				<option value="">{!NA_EM}</option>
			{+END}

			{$SET,year,{START_YEAR}}
			{+START,WHILE,{$GT,{$ADD,1,{END_YEAR}},{$GET,year}}}
				<option {+START,IF,{$EQ,{YEAR},{$GET,year}}} selected="selected"{+END}>{$GET*,year}</option>
				{$INC,year}
			{+END}
		</select>
	</span>
{+END}

{+START,IF,{WANT_MONTH}}
	<span class="vertical-alignment">
		<label for="{NAME*}_month" class="accessibility-hidden">{PRETTY_NAME*} {!MONTH}</label>
		<select id="{NAME*}_month" name="{NAME*}_month"{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} class="form-control input-date{$?,{REQUIRED},-required}">
			{+START,IF,{$NOT,{REQUIRED}}}
				<option value="">{!NA_EM}</option>
			{+END}

			{+START,LOOP,1={!JANUARY}\,2={!FEBRUARY}\,3={!MARCH}\,4={!APRIL}\,5={!MAY}\,6={!JUNE}\,7={!JULY}\,8={!AUGUST}\,9={!SEPTEMBER}\,10={!OCTOBER}\,11={!NOVEMBER}\,12={!DECEMBER}}
				<option {+START,IF,{$EQ,{MONTH},{_loop_key}}} selected="selected"{+END} value="{_loop_key*}">{_loop_var*}</option>
			{+END}
		</select>
	</span>
{+END}

{+START,IF,{WANT_DAY}}
	<span class="vertical-alignment">
		<label for="{NAME*}_day" class="accessibility-hidden">{PRETTY_NAME*} {!DAY}</label>
		<select id="{NAME*}_day" name="{NAME*}_day"{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} class="form-control input-date{$?,{REQUIRED},-required}">
			{+START,IF,{$NOT,{REQUIRED}}}
				<option value="">{!NA_EM}</option>
			{+END}

			{+START,LOOP,1\,2\,3\,4\,5\,6\,7\,8\,9\,10\,11\,12\,13\,14\,15\,16\,17\,18\,19\,20\,21\,22\,23\,24\,25\,26\,27\,28\,29\,30\,31}
				<option {+START,IF,{$EQ,{DAY},{_loop_var}}} selected="selected"{+END}>{_loop_var*}</option>
			{+END}
		</select>
	</span>
{+END}
