<div class="cntRow main_star">
	{+START,IF_NON_EMPTY,{STARS}}
		<div class="cmn-str-row row-top">
			<div class="blk1">
				Avatar
			</div>

			<div class="blk2 adj">
				Details
			</div>

			<div class="blk3 adj2 height-nil">
				Bio
			</div>
		</div>

		{+START,LOOP,STARS}
			<div class="cmn-str-row">
				<div class="blk1">
					{+START,IF_NON_EMPTY,{AVATAR_URL}}
						<img alt="" width="100" height="100" src="{AVATAR_URL*}" />
					{+END}

					{+START,IF_EMPTY,{AVATAR_URL}}
						<img alt="" width="100" height="100" src="{$IMG*,cns_default_avatars/default,0,,1}" />
					{+END}
				</div>

				<div class="blk2">
					<strong>Username :</strong> <a href="{URL*}">{USERNAME*}</a><br />
					<strong>Role Points :</strong> {POINTS*}<br />
					<strong>Rank :</strong> {RANK*}<br />
				</div>

				<div class="blk3">
					{$CPF_VALUE,Bio,{MEMBER_ID}}
				</div>
			</div>
		{+END}
	{+END}

	{+START,IF_EMPTY,{STARS}}
		<p style="font-weight: bold; padding: 10px">Nobody yet &ndash; could you be here?</p>
	{+END}
</div>
