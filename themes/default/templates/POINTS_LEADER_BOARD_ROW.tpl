<tr>
	<th>
		<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>
	</th>
	<td>
		<a href="{POINTS_URL*}" title="{!POINTS}: {USERNAME*}">{POINTS*}</a>
	</td>
	{+START,IF,{HAS_RANK_IMAGES}}
		<td class="leader_board_rank">
			{$CNS_RANK_IMAGE,{ID}}
		</td>
	{+END}
</tr>
