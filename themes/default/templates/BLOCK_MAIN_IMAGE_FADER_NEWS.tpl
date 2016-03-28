{$SET,RAND_FADER_NEWS,{$RAND}}

<section class="box box___block_main_image_fader_news"><div class="box_inner">
	{+START,IF_NON_EMPTY,{TITLE}}
		<h2>{TITLE}</h2>
	{+END}

	<div class="image_fader_news_pic">
		<div class="img_thumb_wrap">
			<a id="image_fader_news_url_{$GET%,RAND_FADER_NEWS}" href="#"><img id="image_fader_news_{$GET,RAND_FADER_NEWS}" src="{$IMG*,blank}" alt="" /></a>
		</div>
	</div>

	<div class="image_fader_news_html" id="image_fader_news_html_{$GET%,RAND_FADER_NEWS}">
		<span aria-busy="true"><img id="loading_image" alt="" src="{$IMG*,loading}" /></span>
	</div>
</div></section>

<noscript>
	{+START,LOOP,NEWS}
		{$TRUNCATE_LEFT,{BODY},600,0,1,1,0.1}
	{+END}
</noscript>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		{$,Variables we will need}
		var fp_animation=document.getElementById('image_fader_news_{$GET;/,RAND_FADER_NEWS}');
		var fp_animation_url=document.getElementById('image_fader_news_url_{$GET;/,RAND_FADER_NEWS}');
		var fp_animation_html=document.getElementById('image_fader_news_html_{$GET;/,RAND_FADER_NEWS}');

		{$,Create fader}
		var fp_animation_news=document.createElement('img');
		fp_animation_news.style.position='absolute';
		fp_animation_news.src='{$IMG;,blank}';
		fp_animation.parentNode.insertBefore(fp_animation_news,fp_animation);
		fp_animation.parentNode.style.position='relative';
		fp_animation.parentNode.style.display='block';

		{$,Copy Tempcode array into JavaScript renderables}
		var data=[];
		{+START,LOOP,NEWS}
			{+START,SET,layout}
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
						<a onclick="return window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}(-1);" rel="prev" accesskey="j" href="#" title="&laquo;&nbsp;{!PREVIOUS}: {!NEWS}" class="light">&laquo;&nbsp;{!PREVIOUS}</a><a id="pause_button_{$GET,RAND_FADER_NEWS}" onclick="return window.main_image_fader_news_pause_{$GET,RAND_FADER_NEWS}();" href="#" title="{!PAUSE}" class="light">{!PAUSE}</a><a onclick="return window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}( 1);" rel="next" accesskey="k" href="#" title="&laquo;&nbsp;{!NEXT}: {!NEWS}" class="light">{!NEXT}&nbsp;&raquo;</a>
					</nav>
				</div>
			{+END}

			data.push(
				{
					html: '{$GET;^/,layout}',
					url: '{URL;^/}',
					image_url: '{IMAGE_URL;/}'
				}
			);
			new Image().src='{IMAGE_URL;/}'; // precache
		{+END}

		{$,Pause function}
		window.main_image_fader_news_pause_{$GET,RAND_FADER_NEWS}=function()
		{
			if (window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS})
			{
				window.clearTimeout(window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS});
				window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS}=null;
				document.getElementById('pause_button_{$GET,RAND_FADER_NEWS}').className='light button_depressed';
			} else
			{
				document.getElementById('pause_button_{$GET,RAND_FADER_NEWS}').className='light';
				window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS}=window.setTimeout(function()
				{
					window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}(1);
				},{MILL%});
			}
			return false;
		};

		{$,Cycling function}
		window.main_image_fader_news_cycle_count_{$GET,RAND_FADER_NEWS}=0;
		window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS}=null;
		window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}=function(dif)
		{
			{$,Cycle}
			var i=window.main_image_fader_news_cycle_count_{$GET,RAND_FADER_NEWS}+dif;
			if (i<0) i=data.length-1;
			if (i>=data.length) i=0;
			window.main_image_fader_news_cycle_count_{$GET,RAND_FADER_NEWS}=i;

			{$,Simple data copy}
			set_inner_html(fp_animation_html,data[i].html);
			fp_animation_url.href=data[i].url;

			{$,Set up fade}
			fp_animation_news.src=fp_animation.src;
			set_opacity(fp_animation_news,1.0);
			fade_transition(fp_animation_news,0,30,-4);
			set_opacity(fp_animation,0.0);
			fade_transition(fp_animation,100,30,4);
			fp_animation.src=data[i].image_url;
			window.setTimeout(function() { {$,Will know dimensions by the time the timeout happens}
				fp_animation_news.style.left=((find_width(fp_animation_news.parentNode)-find_width(fp_animation_news))/2)+'px';
				fp_animation_news.style.top=((find_height(fp_animation_news.parentNode)-find_height(fp_animation_news))/2)+'px';
			},0);

			{$,Set up timer for next time}
			if (window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS})
				window.clearTimeout(window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS});
			document.getElementById('pause_button_{$GET,RAND_FADER_NEWS}').className='light';
			window.main_image_fader_news_cycle_timer_{$GET,RAND_FADER_NEWS}=window.setTimeout(function() {
				window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}(1);
			},{MILL%});

			return false;
		};
		window.main_image_fader_news_cycle_{$GET,RAND_FADER_NEWS}(0);
	});
//]]></script>
