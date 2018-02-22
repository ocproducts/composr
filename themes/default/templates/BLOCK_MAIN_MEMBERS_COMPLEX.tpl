{+START,INCLUDE,CNS_MEMBER_DIRECTORY_SCREEN_FILTERS}{+END}

{$SET,fancy_screen,1}
<div class="block_main_members block_main_members__{DISPLAY_MODE%}{+START,IF_NON_EMPTY,{ITEM_WIDTH}} has_item_width{+END} float_surrounder">
	{+START,LOOP,MEMBER_BOXES}
		{+START,IF,{$EQ,{DISPLAY_MODE},avatars,photos}}
			<div{+START,IF_NON_EMPTY,{ITEM_WIDTH}} style="width: {ITEM_WIDTH*}"{+END} onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{BOX;^*}','auto');">
				<p>
					{+START,IF,{$EQ,{DISPLAY_MODE},avatars}}
						{$SET,image,{$THUMBNAIL,{$?,{$IS_EMPTY,{$AVATAR,{MEMBER_ID}}},{$IMG,cns_default_avatars/default},{$AVATAR,{MEMBER_ID}}},80x80,,,{$IMG,cns_default_avatars/default},pad,both,FFFFFF00}}
					{+END}

					{+START,IF,{$EQ,{DISPLAY_MODE},photos}}
						{$SET,image,{$THUMBNAIL,{$?,{$IS_EMPTY,{$PHOTO,{MEMBER_ID}}},{$IMG,no_image},{$PHOTO,{MEMBER_ID}}},{$CONFIG_OPTION,thumb_width}x{$CONFIG_OPTION,thumb_width},,,{$IMG,no_image},pad,both,FFFFFF00}}
					{+END}

					<a href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}"><img alt="" src="{$ENSURE_PROTOCOL_SUITABILITY*,{$GET,image}}" /></a>
				</p>

				<p>
					<a href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}" onfocus="this.parentNode.onmouseover(event);" onblur="this.parentNode.onmouseout(event);">{$USERNAME*,{MEMBER_ID}}</a>
				</p>
			</div>

			{+START,IF,{BREAK}}
				<br />
			{+END}
		{+END}

		{+START,IF,{$EQ,{DISPLAY_MODE},media}}
			<div{+START,IF_NON_EMPTY,{ITEM_WIDTH}} style="width: {ITEM_WIDTH*}"{+END} class="image_fader_item">
				{+START,NO_PREPROCESSING}
					<div class="box"><div class="box_inner">
						<h3>{GALLERY_TITLE*}</h3>

						{$BLOCK,block=main_image_fader,param={GALLERY_NAME}}

						<ul class="horizontal_links associated_links_block_group">
							<li>
								<a onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{BOX;^*}','auto');" href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}" onfocus="this.parentNode.onmouseover(event);" onblur="this.parentNode.onmouseout(event);">{$USERNAME*,{MEMBER_ID}}</a>
							</li>
						</ul>
					</div></div>
				{+END}
			</div>

			{+START,IF,{BREAK}}
				<br />
			{+END}
		{+END}

		{+START,IF,{$EQ,{DISPLAY_MODE},boxes}}
			<div{+START,IF_NON_EMPTY,{ITEM_WIDTH}} style="width: {ITEM_WIDTH*}"{+END}><div class="box"><div class="box_inner">
				{BOX}
			</div></div></div>

			{+START,IF,{BREAK}}
				<br />
			{+END}
		{+END}
	{+END}
</div>
{$SET,fancy_screen,0}

{+START,IF,{$OR,{INCLUDE_FORM},{$IS_NON_EMPTY,{PAGINATION}}}}
	<div class="box results_table_under"><div class="box_inner float_surrounder">
		{+START,IF,{INCLUDE_FORM}}
			{+START,IF_NON_EMPTY,{SORT}}
				<div class="results_table_sorter">
					{SORT}
				</div>
			{+END}
		{+END}

		{PAGINATION}
	</div></div>
{+END}
