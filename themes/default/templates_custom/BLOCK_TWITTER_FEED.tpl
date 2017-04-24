<section class="box box___block_main_quotes" data-require-javascript="twitter_feed_integration_block" data-tpl="blockTwitterFeed"><div class="box_inner">
	{+START,IF_NON_EMPTY,{TWITTER_TITLE}}<h3>{TWITTER_TITLE*}</h3>{+END}
	{+START,IF_EMPTY,{TWITTER_ERROR}}
		{+START,IF,{$EQ,{STYLE},1}}
			{+START,BOX,@{USER_SCREEN_NAME*} Twitter Profile Details,,accordion,tray_open,,,}
				<table width="100%">
					<tr>
						{+START,IF,{SHOW_PROFILE_IMAGE}}
						<td style="text-align: center" width="56">
							&nbsp;<img src="{USER_PROFILE_IMG_URL*}" />&nbsp;
						</td>
						<td style="background-color: rgb(204, 204, 204); padding: 0; width: 1px"></td>
						{+END}
						<td style="text-align: left">
							<table width="100%">
								<tr>
									<td style="text-align: left">
										<font size="+1"><b>{USER_NAME*}</b></font><br />
										<b><a href="{USER_PAGE_URL*}" target="_blank">@{USER_SCREEN_NAME*}</a></b><br /><br />
										{USER_DESCRIPTION*}<br /><br />
										{USER_LOCATION*} &nbsp;&nbsp;&nbsp; <a href="{USER_URL*}" target="_blank">{USER_URL*}</a><br />
										Joined on {$FROM_TIMESTAMP*,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP*,{USER_CREATED_AT}}}
									</td>
									<td style="width: 8px"></td>
									<td style="text-align: right;vertical-align: middle" nowrap>
										{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},1}}
											{FOLLOW_BUTTON_NORMAL`}<br />
										{+END}
										{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},2}}
											{FOLLOW_BUTTON_LARGE`}<br />
										{+END}
										{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},0}}
											<img src="{$IMG*,{TWITTER_LOGO_IMG_CODE}}" />
										{+END}
										<br />
										<font size="+1">{USER_STATUS_COUNT*}</font> Tweets<br />
										<hr style='height:1px;' />
										<font size="+1">{USER_FOLLOWING_COUNT*}</font> Following<br />
										<hr style='height:1px;' />
										<font size="+1">{USER_FOLLOWERS_COUNT*}</font> Followers<br />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			{+END}
			<div class="webstandards_checker_off">
				{CONTENT`}
			</div>
		{+END}

		{+START,IF,{$OR,{$EQ,{STYLE},2},{$EQ,{STYLE},3}}}
			<div class="webstandards_checker_off">
				{CONTENT`}
			</div>
		{+END}

	{+END}

	{+START,IF_NON_EMPTY,{TWITTER_ERROR}}
		<div class="webstandards_checker_off">
			{+START,IF,{$IS_STAFF}}
			   <b>Twitter Name:</b> <a href='http://www.twitter.com/{USER_SCREEN_NAME&*}' target='_blank'>{USER_SCREEN_NAME*}</a><br />
				<b>Error:</b> {TWITTER_ERROR`}<br />
				You are seeing the block error message(s) because you are an admin.<br />
				Normal web site guests and members won't see this.<br />
			{+END}
			{+START,IF,{$NOT,{$IS_ADMIN}}}
				Sorry, we are experiencing technical difficulties with Twitter.<br />
				Please check back later.<br />
			{+END}
		</div>
	{+END}
</div></section>
