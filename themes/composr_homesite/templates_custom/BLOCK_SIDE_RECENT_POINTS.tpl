<div class="forum-points-stuff-box margin-r-5">
	<h2 class="forum-points-stuff-box-head">
		Last 10 point gifts
	</h2>

	{+START,IF_EMPTY,{GIFTS}}
		<p class="nothing_here">{!NONE}</p>
	{+END}

	{+START,IF_NON_EMPTY,{GIFTS}}
		<table class="gift-table">
			<thead>
				<tr class="top-bar">
					<td class="width46">To</td>
					<td class="width14">&times;pt</td>
					<td class="width40">For</td>
				</tr>
			</thead>

			<tbody>
				{+START,LOOP,GIFTS}
					<tr>
						<td>
							{$SET,image,{$THUMBNAIL,{$?,{$IS_EMPTY,{$AVATAR,{TO_ID}}},{$IMG,cns_default_avatars/default},{$AVATAR,{TO_ID}}},20x20,,,,pad,both,FFFFFF00}}
							<a href="{TO_URL*}"><img alt="{TO_NAME*}" width="20" height="20" src="{$GET*,image}" /></a>
							<a href="{TO_URL*}">{TO_NAME*}</a>
						</td>

						<td>
							{AMOUNT*}
						</td>

						<td>
							{+START,SET,gift_reason}
								{REASON*}

								{+START,IF,{$NOT,{ANONYMOUS}}}
									({FROM_NAME*})
								{+END}
								{+START,IF,{ANONYMOUS}}
									(Anonymous)
								{+END}
							{+END}
							{$TRUNCATE_LEFT,{$GET,gift_reason},26,1,1}
						</td>
					</tr>
				{+END}
			</tbody>
		</table>
	{+END}

	<p>To thank a member for something, visit the points tab of their profile.</p>
</div>
