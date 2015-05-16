{TITLE}

{+START,LOOP,SUBSCRIBERS}
	{+START,IF,{$NEQ,{SUBSCRIBERS},1}}
		<p>
			{TEXT}
		</p>
	{+END}

	{+START,IF_NON_EMPTY,{SUB}}
		<div class="wide_table_wrap"><table class="columned_table results_table wide_table autosized_table">
			<thead>
				<tr>
					<th>{!EMAIL_ADDRESS}</th>
					<th>{!FORENAME}</th>
					<th>{!SURNAME}</th>
					<th>{!NAME}</th>
					<!--
					<th>{!NEWSLETTER_SEND_ID}</th>
					<th>{!NEWSLETTER_HASH}</th>
					-->
				</tr>
			</thead>
			<tbody>
				{SUB}
			</tbody>
		</table></div>

		{+START,IF_NON_EMPTY,{PAGINATION}}
			<div class="float_surrounder pagination_spacing">
				{PAGINATION}
			</div>
		{+END}
	{+END}
	{+START,IF_EMPTY,{SUB}}
		<p class="nothing_here">
			{!NONE}
		</p>
	{+END}
{+END}

{+START,IF_NON_EMPTY,{DOMAINS}}
	<h2>{!DOMAIN_STATISTICS,{$NUMBER_FORMAT*,{DOMAINS}},{$NUMBER_FORMAT*,{DOMAINS}}}</h2>

	<div class="wide_table_wrap"><table class="columned_table wide_table results_table">
		<thead>
			<tr>
				<th>{!DOMAIN}</th>
				<th>{!COUNT_TOTAL}</th>
			</tr>
		</thead>
		<tbody>
			{+START,LOOP,DOMAINS}
				<tr>
					<td>{_loop_key*}</td>
					<td>{$NUMBER_FORMAT*,{_loop_var}}</td>
				</tr>
			{+END}
		</tbody>
	</table></div>
{+END}
