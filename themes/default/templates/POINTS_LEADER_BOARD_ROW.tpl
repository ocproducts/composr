<tr>
	<th>
		<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>
	</th>
	<td>
		<a href="{POINTS_URL*}" title="{$TRUNCATE_LEFT*,{POINTS},25,1}: {USERNAME*}">{$TRUNCATE_LEFT*,{POINTS},25,1}</a>
	</td>
	{+START,IF,{HAS_RANK_IMAGES}}
		<td class="leader_board_rank">
			{$CNS_RANK_IMAGE,{ID}}
		</td>
	{+END}
</tr>
