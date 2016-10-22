{$REQUIRE_JAVASCRIPT,news}

{$SET,RAND_FADER_NEWS,{$RAND}}

{$SET,news_count,{+START,COUNT,NEWS}{+END}}
{$SET,last_news_key,{$SUBTRACT,{$GET,news_count},1}}

{+START,SET,news_items_html_json}
{+START,LOOP,NEWS}
{+START,SET,item_html}
<h3><a href="{URL*`}">{TITLE`}</a></h3>

<div class="meta_details" role="note">
	<ul class="meta_details_list">
		<li>{!POSTED_TIME_SIMPLE,{DATE*`}}</li>
		{+START,SET,author_details}
		{+START,IF,{$IS_NON_EMPTY,{AUTHOR_URL}}}
		{!BY_SIMPLE,<a href="{AUTHOR_URL*`}" title="{!AUTHOR`}: {AUTHOR*`}">{AUTHOR*`}</a>}
		{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
		{+END}

		{+START,IF,{$IS_EMPTY,{AUTHOR_URL}}}
		{+START,IF_NON_EMPTY,{$USERNAME*,{SUBMITTER}}}
		{!BY_SIMPLE,<a rel="author" href="{$MEMBER_PROFILE_URL*`,{SUBMITTER}}">{$USERNAME*`,{SUBMITTER}}</a>}
		{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
		{+END}
		{+END}
		{+END}

		{+START,IF_NON_EMPTY,{$GET,author_details}}
		<li>
			{$GET`,author_details}
		</li>
		{+END}
	</ul>
</div>

{$TRUNCATE_LEFT,{$PREG_REPLACE,<img [^>]*>,,{BODY}},600,0,1,1,0.1}

<div class="pagination">
	<nav class="float_surrounder">
		<a href="#!" onclick=" window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}(-1);" rel="prev" accesskey="j" title="&laquo;&nbsp;{!PREVIOUS}: {!NEWS}" class="light">&laquo;&nbsp;{!PREVIOUS}</a>
		<a href="#!" onclick="window.main_image_fader_news_pause_{$GET,RAND_FADER_NEWS}();" id="pause_button_{$GET,RAND_FADER_NEWS}" title="{!PAUSE}" class="light">{!PAUSE}</a>
		<a href="#!" onclick="window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}(1);" rel="next" accesskey="k" title="&laquo;&nbsp;{!NEXT}: {!NEWS}" class="light">{!NEXT}&nbsp;&raquo;</a>
	</nav>
</div>
{+END}
{$JSON_ENCODE,{$GET,item_html}}{$?,{$NEQ,{$GET,last_news_key},{_loop_key}},\,}
{+END}
{+END}

<section class="box box___block_main_image_fader_news" data-tpl="blockMainImageFaderNews" data-tpl-params="{+START,PARAMS_JSON,RAND_FADER_NEWS,NEWS,MILL,news_items_html_json}{_*}{+END}">
	<div class="box_inner">
	{+START,IF_NON_EMPTY,{TITLE}}
		<h2>{TITLE}</h2>
	{+END}

		<div class="image_fader_news_pic">
			<div class="img_thumb_wrap">
				<a id="image_fader_news_url_{$GET%,RAND_FADER_NEWS}" href="#!"><img id="image_fader_news_{$GET,RAND_FADER_NEWS}" src="{$IMG*,blank}" alt="" /></a>
			</div>
		</div>

		<div class="image_fader_news_html" id="image_fader_news_html_{$GET%,RAND_FADER_NEWS}">
			<span aria-busy="true"><img id="loading_image" alt="" src="{$IMG*,loading}" /></span>
		</div>
	</div>
</section>
