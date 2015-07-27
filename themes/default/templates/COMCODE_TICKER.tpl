{$SET,RAND_ID_TICKER,rand{$RAND}}

{$REQUIRE_JAVASCRIPT,dyn_comcode}

<div class="ticker_wrap" role="marquee" id="ticktickticker{$GET,RAND_ID_TICKER}"></div>

<script>// <![CDATA[
	var tick_pos=[];
	add_event_listener_abstract(window,'load',function() {
		var ticktickticker=document.getElementById('ticktickticker{$GET,RAND_ID_TICKER}');
		if (typeof document.createElement('marquee').scrolldelay=='undefined') // Slower, but chrome does not support marquee's
		{
			var my_id=parseInt(Math.random()*10000);
			tick_pos[my_id]={WIDTH%};
			set_inner_html(ticktickticker,'<div onmouseover="this.mouseisover=true;" onmouseout="this.mouseisover=false;" class="ticker" style="text-indent: {WIDTH|}px; width: {WIDTH|}px;" id="'+my_id+'"><span>{TEXT;~/}<\/span><\/div>');
			window.focused=true;
			add_event_listener_abstract(window,"focus",function() { window.focused=true; });
			add_event_listener_abstract(window,"blur",function() { window.focused=false; });
			window.setInterval(function() { ticker_tick(my_id,{WIDTH%}); },100/{SPEED%});
		} else
		{
			set_inner_html(ticktickticker,'<marquee style="display: block" class="ticker" onmouseover="this.setAttribute(\'scrolldelay\',\'10000\');" onmouseout="this.setAttribute(\'scrolldelay\',(100/{SPEED%}));" scrollamount="2" scrolldelay="'+(100/{SPEED%})+'" width="{WIDTH|}">{TEXT;~/}<\/marquee>');
		}
	});
//]]></script>

<noscript>
	{TEXT}
</noscript>

