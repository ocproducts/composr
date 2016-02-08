<div class="wide_table_wrap"><table class="wide_table results_table spaced_table autosized_table">
	<thead>
		<tr>
			<th>{!AVATAR}</th>
			<th>{!DETAILS}</th>
			<th>{!SIGNATURE}</th>
		</tr>
	</thead>

	{+START,LOOP,STARS}
		<tr>
			<td>
				{+START,IF_NON_EMPTY,{AVATAR_URL}}
					<img style="max-width: 100%" alt="" src="{AVATAR_URL*}" />
				{+END}
			</td>
			<td>
				{!MEMBER}: <a href="{URL*}">{USERNAME*}</a><br /><br />
				Role points: {POINTS*}<br /><br />
				{!RANK}: {RANK*}
			</td>
			<td style="font-size: 0.8em;">
				{SIGNATURE}
			</td>
		</tr>
	{+END}

	{+START,IF_EMPTY,{STARS}}
		<tr>
			<td colspan="3" style="font-weight: bold; padding: 10px">Nobody yet &ndash; could you be here?</td>
		</tr>
	{+END}
</table></div>
