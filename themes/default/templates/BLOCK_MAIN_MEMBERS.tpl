{+START,IF,{INCLUDE_FORM}}
	{+START,IF_PASSED,SYMBOLS}
		<div class="float_surrounder"><div class="pagination alphabetical_jumper">
			{+START,LOOP,SYMBOLS}{+START,IF,{$EQ,{$_GET,{BLOCK_ID}_start},{START}}}<span class="results_page_num">{SYMBOL*}</span>{+END}{+START,IF,{$NEQ,{$_GET,{BLOCK_ID}_start},{START}}}<a class="results_continue alphabetical_jumper_cont" target="_self" href="{$PAGE_LINK*,_SELF:_SELF:{BLOCK_ID}_start={START}:{BLOCK_ID}_max={MAX}:{BLOCK_ID}_sort=m_username ASC}">{SYMBOL*}</a>{+END}{+END}
		</div></div>
	{+END}

	{$REQUIRE_JAVASCRIPT,ajax}
	{$REQUIRE_JAVASCRIPT,ajax_people_lists}

	{+START,IF_NON_EMPTY,{FILTERS_ROW_A}{FILTERS_ROW_B}}
		<div class="box advanced_member_search"><div class="box_inner">
			<form title="{!SEARCH}" action="{$URL_FOR_GET_FORM*,{$SELF_URL}}" target="_self" method="get" autocomplete="off">
				{$HIDDENS_FOR_GET_FORM,{$SELF_URL},{BLOCK_ID}_start,{BLOCK_ID}_max,{BLOCK_ID}_sort,{BLOCK_ID}_filter_*}

				<div class="search_fields float_surrounder">
					<div class="search_button">
						<input onclick="disable_button_just_clicked(this);" accesskey="u" class="button_screen_item buttons__filter" type="submit" value="{!FILTER}{+START,IF_NON_EMPTY,{FILTERS_ROW_B}} &#9745;{+END}" />
					</div>

					{+START,LOOP,{FILTERS_ROW_A}}
						{+START,INCLUDE,CNS_MEMBER_DIRECTORY_SCREEN_FILTER}
							NAME={_loop_key}
							LABEL={_loop_var}
						{+END}
					{+END}
				</div>

				{+START,IF_NON_EMPTY,{FILTERS_ROW_B}}
					<div class="search_fields float_surrounder">
						<div class="search_button">
							<input onclick="window.location.href='{$PAGE_LINK;*,_SELF:_SELF}';" class="button_screen_item buttons__clear" type="button" value="{$,{!RESET_FILTER} }&#9746;" />
						</div>

						{+START,LOOP,{FILTERS_ROW_B}}
							{+START,INCLUDE,CNS_MEMBER_DIRECTORY_SCREEN_FILTER}
								NAME={_loop_key}
								LABEL={_loop_var}
							{+END}
						{+END}
					</div>
				{+END}
			</form>
		</div></div>
	{+END}

	{+START,IF,{$NOT,{HAS_ACTIVE_FILTER}}}
		{+START,IF_NON_EMPTY,{MEMBER_BOXES}}
			<p>{!MEMBER_DIRECTORY_UNFILTERED,{$SITE_NAME*}}</p>
		{+END}

		{+START,IF_EMPTY,{MEMBER_BOXES}}
			<p class="nothing_here">{$?,{$EQ,{DISPLAY_MODE},media},{!MEMBER_DIRECTORY_UNFILTERED_NO_RESULTS_GALLERIES,{$SITE_NAME*}},{!MEMBER_DIRECTORY_UNFILTERED_NO_RESULTS,{$SITE_NAME*}}}</p>
		{+END}
	{+END}
	{+START,IF,{HAS_ACTIVE_FILTER}}
		{+START,IF_NON_EMPTY,{MEMBER_BOXES}}
			<p>{!MEMBER_DIRECTORY_FILTERED,{$SITE_NAME*}}</p>
		{+END}

		{+START,IF_EMPTY,{MEMBER_BOXES}}
			<p class="nothing_here">{!MEMBER_DIRECTORY_FILTERED_NO_RESULTS,{$SITE_NAME*}}</p>
		{+END}
	{+END}
{+END}

{+START,IF,{$NEQ,{DISPLAY_MODE},listing}}
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
{+END}

{+START,IF,{$EQ,{DISPLAY_MODE},listing}}
	{RESULTS_TABLE}
{+END}
