{+START,INCLUDE,CNS_MEMBER_DIRECTORY_SCREEN_FILTERS}{+END}

{$SET,fancy_screen,1}
<div class="block-main-members block-main-members--{DISPLAY_MODE%}{+START,IF_NON_EMPTY,{ITEM_WIDTH}} has-item-width{+END} clearfix">
	{+START,LOOP,MEMBER_BOXES}
		{+START,IF,{$EQ,{DISPLAY_MODE},avatars,photos}}
			<div data-cms-tooltip="{BOX*}"{+START,IF_NON_EMPTY,{ITEM_WIDTH}} style="width: {ITEM_WIDTH*}"{+END}>
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
					<a href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}">{$USERNAME*,{MEMBER_ID}}</a>
				</p>
			</div>

			{+START,IF,{BREAK}}
				<br />
			{+END}
		{+END}

		{+START,IF,{$EQ,{DISPLAY_MODE},media}}
			<div {+START,IF_NON_EMPTY,{ITEM_WIDTH}} style="width: {ITEM_WIDTH*}"{+END} class="image-fader-item">
				{+START,NO_PREPROCESSING}
					<div class="box"><div class="box-inner">
						<h3>{GALLERY_TITLE*}</h3>

						{$BLOCK,block=main_image_fader,param={GALLERY_NAME}}

						<ul class="horizontal-links associated-links-block-group">
							<li>
								<a data-cms-tooltip="{ contents: '{BOX;^*}', triggers: 'hover focus' }" href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}">{$USERNAME*,{MEMBER_ID}}</a>
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
			<div {+START,IF_NON_EMPTY,{ITEM_WIDTH}} style="width: {ITEM_WIDTH*}"{+END}><div class="box"><div class="box-inner">
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
	<div class="box results-table-under">
		<div class="box-inner clearfix">
			{+START,IF,{INCLUDE_FORM}}
				{+START,IF_NON_EMPTY,{SORT}}
					<div class="results-table-sorter">
						{SORT}
					</div>
				{+END}
			{+END}

			{PAGINATION}
		</div>
	</div>
{+END}
