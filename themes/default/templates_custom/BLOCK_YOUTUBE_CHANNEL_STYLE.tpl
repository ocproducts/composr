		{+START,IF,{$EQ,{SHOWPLAYER},1}}
			{$SET,showplayer,1}
		{+END}
		{+START,IF,{$EQ,{SHOWPLAYER},0}}
			{$SET,showplayer,0}
		{+END}
		{+START,IF,{$EQ,{NOTHUMBPLAYER},1}}
			{$SET,nothumbplayer,1}
		{+END}
		{+START,IF,{$EQ,{NOTHUMBPLAYER},0}}
			{$SET,nothumbplayer,0}
		{+END}
		{+START,IF,($EQ,{EMBED_ALLOWED},1}}
			{+START,IF,{$AND,{$EQ,{SHOWPLAYER},1},{$EQ,{EMBEDPLAYER_ALLOWED},0}}}
				{$SET,nothumbplayer,1}
				{$SET,showplayer,0}
			{+END}
		{+END}

		{+START,IF,{$EQ,{STYLE},1}}
			<table border="0" cellpadding="0" cellspacing="4">
				<tr>
				    {+START,IF,{$EQ,{$GET,nothumbplayer},1}}
					<td width='{THUMBWIDTH}' style='vertical-align: middle; text-align: center' nowrap>
						<a href='{VIDEO_URL}' target='_blank'><img src='{THUMBNAIL}' width='{THUMBWIDTH}' height='{THUMBHEIGHT}' alt='{THUMBALT}'></a>
						{+START,IF,{$AND,{$EQ,{EMBEDPLAYER_ALLOWED},0},{$EQ,{EMBED_ALLOWED},1}}}
							<br>Embedding not allowed<br>
							<a href='{VIDEO_URL}' target='_blank'>View on YouTube</a>
						{+END}
					</td>
					<td width='5'>&nbsp;</td>
				    {+END}
					<td style='vertical-align: middle'>
						<table>
							<tr><td style='text-align: right;'><b>Title:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'><a href='{VIDEO_URL}' target='_blank'>{VIDEO_TITLE}</a></td></tr>
							<tr><td style='text-align: right;'><b>Channel:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'><a href='{CHANNEL_URL}' target='_blank'>{CHANNEL_NAME}</a></td></tr>
							<tr><td style='text-align: right;' nowrap="nowrap"><b>Uploaded:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{$FROM_TIMESTAMP,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP,{UPLOAD_DATE}}}</td></tr>
							<tr><td style='text-align: right;'><b>Description:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{$COMCODE,{DESCRIPTION}} </td></tr>
							<tr><td style='text-align: right;'><b>Duration:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{DURATION_NUMERIC} ({DURATION_TEXT})</td></tr>
							{+START,IF,{$NEQ,{FAVORITE_COUNT},0}}<tr><td style='text-align: right;'><b>Favorited:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{FAVORITE_COUNT} person(s) have favorited this video.</td></tr>{+END}
							{+START,IF,{$NEQ,{RATING_NUM_RATES},0}}<tr><td style='text-align: right;'><b>Likes/Dislikes:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{RATING_LIKES}/{RATING_DISLIKES} ({RATING_LIKE_PERCENT}% liked out of {RATING_NUM_RATES} total ratings.)<br> 
								{$SET,i,0}
								{+START,WHILE,{$GT,{$SUBTRACT,{RATING_NUMERIC},{$GET,i}},0}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_full_11x11.gif" align="top">
									{$INC,i}
								{+END}
								{+START,IF,{$GT,{$MULT,{$SUBTRACT,{RATING_NUMERIC},{$GET,i}},100000},49999}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_half_11x11.gif" align="top">
									{$INC,i}
								{+END}
								{+START,WHILE,{$LT,{$GET,i},5}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_empty_11x11.gif" align="top">
									{$INC,i}
								{+END}
								</td></tr>{+END}
							<tr><td style='text-align: right;'><b>Views:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{VIEWS}</td></tr>
						</table>
 					</td>
				</tr>
			</table>
		  {+START,IF,{$EQ,{$GET,showplayer},1}}
		    <br>
		    <div align='{PLAYERALIGN}'> 
		      <iframe width="{PLAYERWIDTH}" height="{PLAYERHEIGHT}" src="{EMBEDVIDEO}" frameborder="0" allowfullscreen></iframe> 
		    </div> 
		  {+END}
		{+END}

		{+START,IF,{$EQ,{STYLE},2}}
			<table border="0" cellpadding="0" cellspacing="4">
				<tr>
				  {+START,IF,{$EQ,{$GET,showplayer},1}}
					<td style='vertical-align: middle'>
						<div align='{PLAYERALIGN}'> 
						<iframe width="{PLAYERWIDTH}" height="{PLAYERHEIGHT}" src="{EMBEDVIDEO}" frameborder="0" allowfullscreen></iframe> 
						</div> 
					</td>
					<td>&nbsp;</td>
					<td style="background-color: rgb(204, 204, 204); padding: 0; width: 1px"></td>
					<td>&nbsp;</td>
					<td style='vertical-align: middle'><table><tr><td>
				  {+END}
				    {+START,IF,{$EQ,{$GET,nothumbplayer},1}}
				     {+START,IF,{$EQ,{$GET,showplayer},1}}
					<table>
						<tr align='left'>
							<td width='{THUMBWIDTH}' style='vertical-align: middle; text-align: center' nowrap>
								<a href='{VIDEO_URL}' target='_blank'><img src='{THUMBNAIL}' width='{THUMBWIDTH}' height='{THUMBHEIGHT}' alt='{THUMBALT}'></a>
								{+START,IF,{$AND,{$EQ,{EMBEDPLAYER_ALLOWED},0},{$EQ,{EMBED_ALLOWED},1}}}
									<br>Embedding not allowed<br>
									<a href='{VIDEO_URL}' target='_blank'>View on YouTube</a>
								{+END}
							</td>
						</tr>
					</table>
				     {+END}
				     {+START,IF,{$EQ,{$GET,showplayer},0}}
					<td><table><tr>
					<td width='{THUMBWIDTH}' style='vertical-align: middle; text-align: center' nowrap>
						<a href='{VIDEO_URL}' target='_blank'><img src='{THUMBNAIL}' width='{THUMBWIDTH}' height='{THUMBHEIGHT}' alt='{THUMBALT}'></a>
						{+START,IF,{$AND,{$EQ,{EMBEDPLAYER_ALLOWED},0},{$EQ,{EMBED_ALLOWED},1}}}
							<br>Embedding not allowed<br>
							<a href='{VIDEO_URL}' target='_blank'>View on YouTube</a>
						{+END}
					</td>
					<td>
				     {+END}
				    {+END}
						<table>
							<tr><td style='text-align: right;'><b>Title:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'><a href='{VIDEO_URL}' target='_blank'>{VIDEO_TITLE}</a></td></tr>
							<tr><td style='text-align: right;'><b>Channel:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'><a href='{CHANNEL_URL}' target='_blank'>{CHANNEL_NAME}</a></td></tr>
							<tr><td style='text-align: right;' nowrap="nowrap"><b>Uploaded:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{$FROM_TIMESTAMP,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP,{UPLOAD_DATE}}}</td></tr>
							<tr><td style='text-align: right;'><b>Description:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{$COMCODE,{DESCRIPTION}} </td></tr>
							<tr><td style='text-align: right;'><b>Duration:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{DURATION_NUMERIC} ({DURATION_TEXT})</td></tr>
							{+START,IF,{$NEQ,{FAVORITE_COUNT},0}}<tr><td style='text-align: right;'><b>Favorited:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{FAVORITE_COUNT} person(s) have favorited this video.</td></tr>{+END}
							{+START,IF,{$NEQ,{RATING_NUM_RATES},0}}<tr><td style='text-align: right;'><b>Likes/Dislikes:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{RATING_LIKES}/{RATING_DISLIKES} ({RATING_LIKE_PERCENT}% liked out of {RATING_NUM_RATES} total ratings.)<br> 
								{$SET,i,0}
								{+START,WHILE,{$GT,{$SUBTRACT,{RATING_NUMERIC},{$GET,i}},0}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_full_11x11.gif" align="top">
									{$INC,i}
								{+END}
								{+START,IF,{$GT,{$MULT,{$SUBTRACT,{RATING_NUMERIC},{$GET,i}},100000},49999}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_half_11x11.gif" align="top">
									{$INC,i}
								{+END}
								{+START,WHILE,{$LT,{$GET,i},5}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_empty_11x11.gif" align="top">
									{$INC,i}
								{+END}
								</td></tr>{+END}
							<tr><td style='text-align: right;'><b>Views:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{VIEWS}</td></tr>
						</table>
					</td></tr></table></td>
				</tr>
			</table>
		{+END}

		{+START,IF,{$EQ,{STYLE},3}}
			<table border="0" cellpadding="0" cellspacing="4">
				<tr>
				  {+START,IF,{$EQ,{$GET,showplayer},1}}
					<td style='vertical-align: middle'>
						<div align='{PLAYERALIGN}'> 
						<iframe width="{PLAYERWIDTH}" height="{PLAYERHEIGHT}" src="{EMBEDVIDEO}" frameborder="0" allowfullscreen></iframe> 
						</div> 
					</td>
					<td>&nbsp;</td>
					<td style="background-color: rgb(204, 204, 204); padding: 0; width: 1px"></td>
					<td>&nbsp;</td>
					<td style='vertical-align: middle'><table><tr><td>
				  {+END}
				    {+START,IF,{$EQ,{$GET,nothumbplayer},1}}
				     {+START,IF,{$EQ,{$GET,showplayer},1}}
					<table>
						<tr align='left'>
							<td width='{THUMBWIDTH}' style='vertical-align: middle; text-align: center' nowrap>
								<a href='{VIDEO_URL}' target='_blank'><img src='{THUMBNAIL}' width='{THUMBWIDTH}' height='{THUMBHEIGHT}' alt='{THUMBALT}'></a>
								{+START,IF,{$AND,{$EQ,{EMBEDPLAYER_ALLOWED},0},{$EQ,{EMBED_ALLOWED},1}}}
									<br>Embedding not allowed<br>
									<a href='{VIDEO_URL}' target='_blank'>View on YouTube</a>
								{+END}
							</td>
						</tr>
					</table>
				     {+END}
				     {+START,IF,{$EQ,{$GET,showplayer},0}}
					<td><table><tr>
					<td width='{THUMBWIDTH}' style='vertical-align: middle; text-align: center' nowrap>
						<a href='{VIDEO_URL}' target='_blank'><img src='{THUMBNAIL}' width='{THUMBWIDTH}' height='{THUMBHEIGHT}' alt='{THUMBALT_0}'></a>
						{+START,IF,{$AND,{$EQ,{EMBEDPLAYER_ALLOWED},0},{$EQ,{EMBED_ALLOWED},1}}}
							<br>Embedding not allowed<br>
							<a href='{VIDEO_URL}' target='_blank'>View on YouTube</a>
						{+END}
					</td>
					<td>
				     {+END}
				    {+END}
						<table>
							<tr><td><b><a href='{VIDEO_URL}' target='_blank'>{VIDEO_TITLE}</a></b></td></tr>
							<tr><td><b>{$FROM_TIMESTAMP,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP,{UPLOAD_DATE}}}</b></td></tr>
							<tr><td>{$COMCODE,{DESCRIPTION}}</td></tr>
							{+START,IF_NON_EMPTY,{FOR_MORE_URL}}{+START,IF_EMPTY,{FOR_MORE_TEXT}}<tr><td><br />{FOR_MORE_LEAD} <a href='{FOR_MORE_URL}'>{FOR_MORE_URL}</a></td></tr>{+END}{+END}{+START,IF_NON_EMPTY,{FOR_MORE_URL}}{+START,IF_NON_EMPTY,{FOR_MORE_TEXT}}<tr><td><br />{FOR_MORE_LEAD} <a href='{FOR_MORE_URL}'>{FOR_MORE_TEXT}</a></td></tr>{+END}{+END} 
						</table>
					</td></tr></table></td>
				</tr>
			</table>
		{+END}
		
		{+START,IF,{$EQ,{STYLE},4}}
		  {+START,IF,{$EQ,{$GET,showplayer},1}}
		    <div align='{PLAYERALIGN}'> 
		      <iframe width="{PLAYERWIDTH}" height="{PLAYERHEIGHT}" src="{EMBEDVIDEO}" frameborder="0" allowfullscreen></iframe> 
		    </div> 
		    <br>
		  {+END}
		    <div align='{PLAYERALIGN}'> 
			<table border="0" cellpadding="0" cellspacing="4">
				<tr>
				    {+START,IF,{$EQ,{$GET,nothumbplayer},1}}
					<td width='{THUMBWIDTH}' style='vertical-align: middle; text-align: center' nowrap>
						<a href='{VIDEO_URL}' target='_blank'><img src='{THUMBNAIL}' width='{THUMBWIDTH}' height='{THUMBHEIGHT}' alt='{THUMBALT}'></a>
						{+START,IF,{$AND,{$EQ,{EMBEDPLAYER_ALLOWED},0},{$EQ,{EMBED_ALLOWED},1}}}
							<br>Embedding not allowed<br>
							<a href='{VIDEO_URL}' target='_blank'>View on YouTube</a>
						{+END}
					</td>
					<td width='5'>&nbsp;</td>
				    {+END}
					<td style='vertical-align: middle'>
						<table>
							<tr><td style='text-align: right;'><b>Title:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'><a href='{VIDEO_URL}' target='_blank'>{VIDEO_TITLE}</a></td></tr>
							<tr><td style='text-align: right;'><b>Channel:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'><a href='{CHANNEL_URL}' target='_blank'>{CHANNEL_NAME}</a></td></tr>
							<tr><td style='text-align: right;' nowrap="nowrap"><b>Uploaded:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{$FROM_TIMESTAMP,%d %B %Y\, %I:%M:%S %p,{$TO_TIMESTAMP,{UPLOAD_DATE}}}</td></tr>
							<tr><td style='text-align: right;'><b>Description:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{$COMCODE,{DESCRIPTION}} </td></tr>
							<tr><td style='text-align: right;'><b>Duration:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{DURATION_NUMERIC} ({DURATION_TEXT})</td></tr>
							{+START,IF,{$NEQ,{FAVORITE_COUNT},0}}<tr><td style='text-align: right;'><b>Favorited:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{FAVORITE_COUNT} person(s) have favorited this video.</td></tr>{+END}
							{+START,IF,{$NEQ,{RATING_NUM_RATES},0}}<tr><td style='text-align: right;'><b>Likes/Dislikes:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{RATING_LIKES}/{RATING_DISLIKES} ({RATING_LIKE_PERCENT}% liked out of {RATING_NUM_RATES} total ratings.)<br> 
								{$SET,i,0}
								{+START,WHILE,{$GT,{$SUBTRACT,{RATING_NUMERIC},{$GET,i}},0}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_full_11x11.gif" align="top">
									{$INC,i}
								{+END}
								{+START,IF,{$GT,{$MULT,{$SUBTRACT,{RATING_NUMERIC},{$GET,i}},100000},49999}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_half_11x11.gif" align="top">
									{$INC,i}
								{+END}
								{+START,WHILE,{$LT,{$GET,i},5}}
									<img style="border: 0px none; margin: 0px; padding: 0px; vertical-align: middle; font-size: 11px;" alt="" src="http://gdata.youtube.com/static/images/icn_star_empty_11x11.gif" align="top">
									{$INC,i}
								{+END}
								</td></tr>{+END}
							<tr><td style='text-align: right;'><b>Views:</b></td><td width='5'>&nbsp;</td><td style='text-align: left;'>{VIEWS}</td></tr>
						</table>
 					</td>
				</tr>
			</table>
			</div>
		{+END}

		    <br><hr style='height:1px;' /><br>
