{$REQUIRE_JAVASCRIPT,dyn_comcode}

{+START,SET,news_ticker_text}
	<ol class="horizontal_ticker">
		{+START,LOOP,POSTS}
			<li><a title="{$STRIP_TAGS,{NEWS_TITLE}}: {DATE*}" class="nvn" href="{FULL_URL*}">{NEWS_TITLE}</a></li>
		{+END}
	</ol>
{+END}

{$SET,bottom_news_id,{$RAND}}

<div class="ticker_wrap" role="marquee" id="ticktickticker_news{$GET%,bottom_news_id}"></div>
<script>// <![CDATA[
	var tick_pos=[];
	add_event_listener_abstract(window,'load',function() {
		var ticktickticker=document.getElementById('ticktickticker_news{$GET%,bottom_news_id}');
		if (typeof document.createElement('marquee').scrolldelay=='undefined') // Slower, but chrome does not support marquee's
		{
			var my_id=parseInt(Math.random()*10000);
			tick_pos[my_id]=400;
			set_inner_html(ticktickticker,'<div onmouseover="this.mouseisover=true;" onmouseout="this.mouseisover=false;" class="ticker" style="text-indent: 400px; width: 400px;" id="'+my_id+'"><span>{$GET;~/,news_ticker_text}<\/span><\/div>');
			window.focused=true;
			add_event_listener_abstract(window,"focus",function() { window.focused=true; });
			add_event_listener_abstract(window,"blur",function() { window.focused=false; });
			window.setInterval(function() { ticker_tick(my_id,400); }, 50);
		} else
		{
			set_inner_html(ticktickticker,'<marquee style="display: block" class="ticker" onmouseover="this.setAttribute(\'scrolldelay\',\'10000\');" onmouseout="this.setAttribute(\'scrolldelay\',50);" scrollamount="2" scrolldelay="'+(50)+'" width="400">{$GET;~/,news_ticker_text}<\/marquee>');
		}
	});
//]]></script>
<noscript>
	{$GET,news_ticker_text}
</noscript>

