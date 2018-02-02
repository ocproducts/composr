<div itemscope="itemscope" itemtype="http://schema.org/ImageObject">
	{TITLE}

	<div class="meta-details" role="note">
		<ul class="meta-details-list">
			<li>
				{!BY_SIMPLE,<a rel="author" href="{$MEMBER_PROFILE_URL*,{SUBMITTER}}" itemprop="author">{$USERNAME*,{SUBMITTER},1}}</a>
				{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
			</li>
			<li>{!ADDED_SIMPLE,<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{ADD_DATE_RAW}}" itemprop="datePublished">{ADD_DATE*}</time>}</li>
			{+START,IF,{$INLINE_STATS}}<li>{!VIEWS_SIMPLE,{VIEWS*}}</li>{+END}
		</ul>
	</div>

	<p class="media-box">
		<img class="scale-down" alt="{!IMAGE}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" itemprop="contentURL" />
	</p>

	{+START,IF_NON_EMPTY,{CAPTION}}
		<div itemprop="caption">
			{$PARAGRAPH,{CAPTION}}
		</div>
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
	</div>

	{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
	{+START,INCLUDE,STAFF_ACTIONS}
		1_URL={EDIT_URL*}
		1_TITLE={!EDIT_IOTD}
		1_ACCESSKEY=q
		1_REL=edit
		1_ICON=admin/edit_this
	{+END}

	<div class="content-screen-comments">
		{COMMENT_DETAILS}
	</div>

	{+START,IF_NON_EMPTY,{EDIT_DATE_RAW}}
		<div class="edited" role="note">
			<img alt="" width="9" height="6" src="{$IMG*,edited}" /> {!EDITED}
			<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{EDIT_DATE_RAW}}">{$DATE*,,,,{EDIT_DATE_RAW}}</time>
		</div>
	{+END}

	{$REVIEW_STATUS,iotd,{ID}}

	{+START,IF,{$THEME_OPTION,show_screen_actions}}{$BLOCK,failsafe=1,block=main_screen_actions,title={$METADATA,title}}{+END}
</div>
