{$SET,reply_id,{$RAND}}
{$SET,retweet_id,{$RAND}}
{$SET,favorite_id,{$RAND}}
{+START,IF,{$EQ,{STYLE},1}}
	 <div class="box" style="margin:0;">
		<table width="100%" border="0" cellpadding="0" cellspacing="4">
			<tr>
				<td>
					{TWEET_TEXT`}
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%">
						<tr>
							<td style="text-align: left">
								{$FROM_TIMESTAMP*,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP,{TWEET_CREATED_AT}}} &ndash; {TWEET_TIME_AGO*}
							</td>
							<td style="text-align: right">
								<a href="{REPLY_URL*}" rel="nofollow"><img src="{$IMG*,twitter_feed/reply}" id="{$GET*,reply_id}" title="Reply to this Tweet" /></a> &nbsp;
								<a href="{RETWEET_URL*}" rel="nofollow"><img src="{$IMG*,twitter_feed/retweet}" id="{$GET*,retweet_id}" title="Retweet this Tweet" /></a> &nbsp;
								<a href="{FAVORITE_URL}" rel="nofollow"><img src="{$IMG*,twitter_feed/favorite}" id="{$GET*,favorite_id}" title="Favorite this Tweet" /></a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
{+END}

{+START,IF,{$EQ,{STYLE},2}}
	<table width="100%" border="0" cellpadding="0" cellspacing="4">
		<tr>
			<td>
				<table width="100%">
					<tr>
						<td>
							<table width="100%">
								<tr>
									{+START,IF,{SHOW_PROFILE_IMAGE}}
										<td style="text-align: center; width: 56px">
											&nbsp;<img src="{USER_PROFILE_IMG_URL*}" />&nbsp;
										</td>
										<td width="10" style="text-align: center">
											<table height="44"><tr><td style="background-color: rgb(204, 204, 204); padding: 0; height: 44px; width: 1px"></td></tr></table>
										</td>
									{+END}
									<td style="text-align: left">
										<table width="100%">
											<tr>
												<td style="text-align: left">
													<b>{USER_NAME*}</b><br />
													<a href="{USER_PAGE_URL*}" target="_blank">@{USER_SCREEN_NAME*}</a>
												</td>
												<td style="text-align: right">
													{+START,IF,{FOLLOW_BUTTON_SIZE}}
														{FOLLOW_BUTTON_NORMAL`}
													{+END}
													{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},2}}
														{FOLLOW_BUTTON_LARGE`}
													{+END}
													{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},0}}
														<img src="{$IMG*,{TWITTER_LOGO_IMG_CODE}}" />
													{+END}
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							{TWEET_TEXT`}
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%">
								<tr>
									<td style="text-align: left">
										{$FROM_TIMESTAMP*,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP,{TWEET_CREATED_AT}}} &ndash; {TWEET_TIME_AGO*}
									</td>
									<td style="text-align: right">
										<a href="{REPLY_URL*}" rel="nofollow"><img src="{$IMG*,twitter_feed/reply}" id="{$GET*,reply_id}" title="Reply to this Tweet" /></a> &nbsp;
										<a href="{RETWEET_URL*}" rel="nofollow"><img src="{$IMG*,twitter_feed/retweet}" id="{$GET*,retweet_id}" title="Retweet this Tweet" /></a> &nbsp;
										<a href="{FAVORITE_URL}" rel="nofollow"><img src="{$IMG*,twitter_feed/favorite}" id="{$GET*,favorite_id}" title="Favorite this Tweet" /></a>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br /><hr style='height:1px;' /><br />
{+END}

{+START,IF,{$EQ,{STYLE},3}}
	<table width="100%" border="0" cellpadding="0" cellspacing="4">
		<tr>
			{+START,IF,{SHOW_PROFILE_IMAGE}}
				<td style="vertical-align: middle; text-align: center; width: 56px">
					<img src="{USER_PROFILE_IMG_URL}" />
				</td>
				<td style="background-color: rgb(204, 204, 204); padding: 0; width: 1px"></td>
			{+END}
			<td>
				<table width="100%">
					<tr>
						<td>
							{+START,BOX,Click Here For Details,,accordion,tray_closed,,,}
								<table width="100%">
									<tr>
										<td>
											<table width="100%">
												<tr>
													<td style="text-align: left">
														<b>{USER_NAME*}</b> (<a href="{USER_PAGE_URL*}" target="_blank">@{USER_SCREEN_NAME*}</a>)
													</td>
													<td style="text-align: right">
														{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},1}}
															{FOLLOW_BUTTON_NORMAL`}
														{+END}
														{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},2}}
															{FOLLOW_BUTTON_LARGE`}
														{+END}
														{+START,IF,{$EQ,{FOLLOW_BUTTON_SIZE},0}}
															<img src="{$IMG*,{TWITTER_LOGO_IMG_CODE}}" />
														{+END}
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>
											<table width="100%">
												<tr>
													<td>
														Retweets: {TWEET_RETWEET_COUNT*}
													</td>
													<td style="text-align: right">
														<a href="{REPLY_URL*}" rel="nofollow"><img src="{$IMG*,twitter_feed/reply}" id="{$GET*,reply_id}" title="Reply to this Tweet" /></a> &nbsp;
														<a href="{RETWEET_URL*}" rel="nofollow"><img src="{$IMG*,twitter_feed/retweet}" id="{$GET*,retweet_id}" title="Retweet this Tweet" /></a> &nbsp;
														<a href="{FAVORITE_URL}" rel="nofollow"><img src="{$IMG*,twitter_feed/favorite}" id="{$GET*,favorite_id}" title="Favorite this Tweet" /></a>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							{+END}
						</td>
					</tr>
					<tr>
						<td>
							{TWEET_TEXT`}
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%">
								<tr>
									<td style="text-align: left">
										{$FROM_TIMESTAMP*,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP,{TWEET_CREATED_AT}}} &ndash; {TWEET_TIME_AGO*}
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br /><hr style="height:1px;" /><br />
{+END}
{+START,IF,{$GT,{$VERSION},8}}
	<script>// <![CDATA[
		$(function() {
			create_rollover('{$GET;/,reply_id}','{$IMG;/,twitter_feed/reply_hover}');
		});
	//]]></script>

	<script>// <![CDATA[
		$(function() {
			create_rollover('{$GET;/,retweet_id}','{$IMG;/,twitter_feed/retweet_hover}');
		});
	//]]></script>

	<script>// <![CDATA[
		$(function() {
			create_rollover('{$GET;/,favorite_id}','{$IMG;/,twitter_feed/favorite_hover}');
		});
	//]]></script>
{+END}
