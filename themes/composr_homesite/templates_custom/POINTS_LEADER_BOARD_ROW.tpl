<tr>
	<td class="width46">
		{$SET,image,{$THUMBNAIL,{$?,{$IS_EMPTY,{$AVATAR,{ID}}},{$IMG,cns_default_avatars/default},{$AVATAR,{ID}}},20x20,,,,pad,both,FFFFFF00}}
		<a href="{PROFILE_URL*}"><img alt="" width="20" height="20" src="{$GET*,image}" /></a>
		<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>
	</td>

	<td class="width14">
		<a href="{POINTS_URL*}" title="{$TRUNCATE_LEFT*,{POINTS},25,1}: {USERNAME*}">{$TRUNCATE_LEFT*,{POINTS},25,1}</a>
	</td>

	<td class="width40">
		{$CNS_RANK_IMAGE,{ID}}
	</td>
</tr>
