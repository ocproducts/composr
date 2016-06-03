<div itemscope="itemscope" itemtype="http://schema.org/{$?,{BLOG},BlogPosting,NewsArticle}">
	{TITLE}

	{+START,IF_PASSED,WARNING_DETAILS}
		{WARNING_DETAILS}
	{+END}

	<div class="meta_details" role="note">
		<ul class="meta_details_list">
			{+START,IF,{$INLINE_STATS}}<li>{!VIEWS_SIMPLE,{VIEWS*}}</li>{+END}
			<li>{!ADDED_SIMPLE,<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{ADD_DATE_RAW}}" itemprop="datePublished">{DATE*}</time>}</li>
			{+START,IF_NON_EMPTY,{AUTHOR_URL}}
				<li>
					<span class="field_name">{!AUTHOR}:</span> <a rel="author" itemprop="author" href="{AUTHOR_URL*}" title="{!AUTHOR}: {AUTHOR*}">{AUTHOR*}</a>
					{+START,INCLUDE,MEMBER_TOOLTIP}SUBMITTER={$AUTHOR_MEMBER,{AUTHOR}}{+END}
				</li>
			{+END}
			{+START,IF_EMPTY,{AUTHOR_URL}}{+START,IF_NON_EMPTY,{$USERNAME,{SUBMITTER},1}}
				<li>
					{!BY_SIMPLE,<a rel="author" href="{$MEMBER_PROFILE_URL*,{SUBMITTER}}" itemprop="author">{$USERNAME*,{SUBMITTER},1}</a>}
					{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
				</li>
			{+END}{+END}
		</ul>
	</div>

	<div itemprop="articleBody" class="float_surrounder">
		{NEWS_FULL}
	</div>

	{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,news,{ID}}}
	{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

	{+START,IF,{$CONFIG_OPTION,show_content_tagging}}{TAGS}{+END}

	{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
	{+START,INCLUDE,STAFF_ACTIONS}
		1_URL={SUBMIT_URL*}
		1_TITLE={$?,{BLOG},{!ADD_NEWS_BLOG},{!ADD_NEWS}}
		1_REL=add
		1_NOREDIRECT=1
		1_ICON=menu/_generic_admin/add_one
		2_URL={EDIT_URL*}
		2_ACCESSKEY=q
		2_TITLE={!EDIT_LINK}
		2_ICON=menu/_generic_admin/edit_this
		2_REL=edit
		3_URL={NEWSLETTER_URL*}
		3_TITLE={+START,IF_NON_EMPTY,{NEWSLETTER_URL}}{!newsletter:NEWSLETTER_SEND}{+END}
		3_ICON=menu/site_meta/newsletters
	{+END}

	<div class="float_surrounder lined_up_boxes">
		{+START,IF_NON_EMPTY,{TRACKBACK_DETAILS}}
			<div class="trackbacks right">
				{TRACKBACK_DETAILS}
			</div>
		{+END}
		{+START,IF_NON_EMPTY,{RATING_DETAILS}}
			<div class="ratings right">
				{RATING_DETAILS}
			</div>
		{+END}

		<aside class="box box___news_entry_screen"><nav class="box_inner">
			<p class="lonely_label">
				{$?,{BLOG},{!BLOG_NEWS_UNDER_THESE},{!NEWS_UNDER_THESE}}
			</p>
			<ul>
				{+START,LOOP,CATEGORIES}
					<li><a href="{$PAGE_LINK*,_SELF:news:browse:{_loop_key}{$?,{BLOG},:blog=1,}}">{_loop_var*}</a></li>
				{+END}
			</ul>

			{+START,IF,{$NOT,{$_GET,blog}}}
				{$,Actually breadcrumbs will do fine!,<div>
					<a class="button_screen buttons__all2" rel="archives" href="\{ARCHIVE_URL*\}"><span>\{!VIEW_ARCHIVE\}</span></a>
				</div>}
			{+END}
		</nav></aside>
	</div>

	{$REVIEW_STATUS,news,{ID}}

	<div class="content_screen_comments">
		{COMMENT_DETAILS}
	</div>

	{+START,IF,{$CONFIG_OPTION,show_screen_actions}}{+START,IF_PASSED,_TITLE}{$BLOCK,failsafe=1,block=main_screen_actions,title={_TITLE}}{+END}{+END}

	{+START,IF_NON_EMPTY,{EDIT_DATE_RAW}}
		<div class="edited" role="note">
			<img alt="" src="{$IMG*,1x/edited}" srcset="{$IMG*,2x/edited} 2x" />
			{!EDITED}
			<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{EDIT_DATE_RAW}}">{$DATE*,,,,{EDIT_DATE_RAW}}</time>
		</div>
	{+END}
</div>
