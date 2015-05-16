{+START,SET,media}
	<object width="{WIDTH*}" height="{HEIGHT*}" type="application/x-shockwave-flash" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
		<param name="movie" value="{URL*}" />
		<param name="quality" value="high" />
		<param name="pluginspage" value="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" />

		<!--[if !IE]> -->
			<object width="{WIDTH*}" height="{HEIGHT*}" data="{URL*}" type="application/x-shockwave-flash">
				<param name="movie" value="{URL*}" />
				<param name="quality" value="high" />
				<param name="pluginspage" value="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" />

				{!ANIMATION}
			</object>
		<!-- <![endif]-->
	</object>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated_details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}
{+END}
{+START,IF_PASSED_AND_TRUE,FRAMED}
	<figure>
		{$GET,media}
	</figure>
{+END}
{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
	{$GET,media}
{+END}
