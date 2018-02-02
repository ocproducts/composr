<div class="news-entry-screen" itemscope="itemscope" itemtype="http://schema.org/{$?,{BLOG},BlogPosting,NewsArticle}">
	{TITLE}

	{+START,IF_PASSED,WARNING_DETAILS}
		{WARNING_DETAILS}
	{+END}

	<div class="meta-details" role="note">
		<ul class="meta-details-list">
			{+START,IF,{$INLINE_STATS}}<li>{!VIEWS_SIMPLE,{VIEWS*}}</li>{+END}
			<li>{!ADDED_SIMPLE,<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{ADD_DATE_RAW}}" itemprop="datePublished">{DATE*}</time>}</li>
			{+START,IF_NON_EMPTY,{AUTHOR_URL}}
				<li>
					<span class="field-name">{!AUTHOR}:</span> <a rel="author" itemprop="author" href="{AUTHOR_URL*}" title="{!AUTHOR}: {AUTHOR*}">{AUTHOR*}</a>
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

	<div itemprop="articleBody" class="float-surrounder">
		{NEWS_FULL}
	</div>

	{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,news,{ID}}}
	{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

	{+START,IF,{$THEME_OPTION,show_content_tagging}}{TAGS}{+END}

	{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
	{+START,INCLUDE,STAFF_ACTIONS}
		1_URL={SUBMIT_URL*}
		1_TITLE={$?,{BLOG},{!ADD_NEWS_BLOG},{!ADD_NEWS}}
		1_REL=add
		1_NOREDIRECT=1
		1_ICON=admin/add
		2_URL={EDIT_URL*}
		2_ACCESSKEY=q
		2_TITLE={!EDIT_LINK}
		2_ICON=admin/edit_this
		2_REL=edit
		3_URL={NEWSLETTER_URL*}
		3_TITLE={+START,IF_NON_EMPTY,{NEWSLETTER_URL}}{!newsletter:NEWSLETTER_SEND}{+END}
		3_ICON=menu/site_meta/newsletters
		{+START,IF,{$ADDON_INSTALLED,tickets}}
			4_URL={$PAGE_LINK*,_SEARCH:report_content:content_type=news:content_id={ID}:redirect={$SELF_URL&}}
			4_TITLE={!report_content:REPORT_THIS}
			4_ICON=buttons/report
			4_REL=report
		{+END}
	{+END}

	<div class="float-surrounder lined-up-boxes">
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

		<aside class="box box---news-entry-screen"><nav class="box-inner">
			<p class="lonely-label">
				{$?,{BLOG},{!BLOG_NEWS_UNDER_THESE},{!NEWS_UNDER_THESE}}
			</p>
			<ul>
				{+START,LOOP,CATEGORIES}
					<li><a href="{$PAGE_LINK*,_SELF:_SELF:browse:{_loop_key}{$?,{BLOG},:blog=1,}}">{_loop_var*}</a></li>
				{+END}
			</ul>

			{+START,IF,{$NOT,{$_GET,blog}}}
				{$,Actually breadcrumbs will do fine!,<div>
					<a class="button-screen buttons--all2" rel="archives" href="\{ARCHIVE_URL*\}"><span>\{!VIEW_ARCHIVE\}</span></a>
				</div>}
			{+END}
		</nav></aside>
	</div>

	{$REVIEW_STATUS,news,{ID}}

	<div class="content-screen-comments">
		{COMMENT_DETAILS}
	</div>

	{+START,IF,{$THEME_OPTION,show_screen_actions}}{+START,IF_PASSED,_TITLE}{$BLOCK,failsafe=1,block=main_screen_actions,title={_TITLE}}{+END}{+END}

	{+START,IF_NON_EMPTY,{EDIT_DATE_RAW}}
		<div class="edited" role="note">
			<img alt="" width="9" height="6" src="{$IMG*,edited}" />
			{!EDITED}
			<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{EDIT_DATE_RAW}}">{$DATE*,,,,{EDIT_DATE_RAW}}</time>
		</div>
	{+END}
</div>
