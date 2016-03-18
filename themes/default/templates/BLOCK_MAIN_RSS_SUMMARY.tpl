<div class="float_surrounder rss_summary">
	{+START,IF_EMPTY,{CATEGORY_IMG}}
		{+START,IF_NON_EMPTY,{AUTHOR}}
			<div class="newscat_img newscat_img_author">
				<div class="news_by">{AUTHOR}</div>
			</div>
		{+END}
	{+END}
	{+START,IF_NON_EMPTY,{CATEGORY_IMG}}
		<div class="newscat_img_author">
			<img src="{$ENSURE_PROTOCOL_SUITABILITY*,{CATEGORY_IMG}}" title="{CATEGORY`}" alt="{CATEGORY`}" />
			{CATEGORY`}
		</div>
	{+END}

	<h3><a href="{FULL_URL_RAW*}">{$TRUNCATE_LEFT,{NEWS_TITLE`},70,1,1}</a></h3>

	{+START,IF,{$OR,{$IS_NON_EMPTY,{DATE}},{$AND,{$NOT,{$IN_STR,{CATEGORY},<img}},{$IS_NON_EMPTY,{CATEGORY}}}}}
		<div class="meta_details" role="note">
			<ul class="meta_details_list">
				{+START,IF_NON_EMPTY,{DATE}}<li>{!POSTED_TIME_SIMPLE,{DATE*}}</li>{+END}
				{+START,IF,{$AND,{$NOT,{$IN_STR,{CATEGORY},<img}},{$IS_NON_EMPTY,{CATEGORY}}}}<li>{!IN,{CATEGORY}}</li>{+END}
			</ul>
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{NEWS}}
		{+START,IF,{$NOT,{$IN_STR,{NEWS},<p>}}}<p class="news_summary_p">{+END}{NEWS}{+START,IF,{$NOT,{$IN_STR,{NEWS},<p>}}}</p>{+END}
	{+END}

	{+START,COMMENT}
		<div>
			<div>
				<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{!EXPAND}</a>
			</div>

			<div class="toggleable_tray_pulldown_spacer toggleable_tray" style="display: {$JS_ON,none,block}" aria-expanded="false">
				{NEWS_FULL}
			</div>
		</div>
	{+END}
</div>

<ul class="horizontal_links associated_links_block_group">
	<li>{FULL_URL}</li>
</ul>

