<script>// <![CDATA[
	$(function() {
		replace_comments_form_with_ajax('{OPTIONS;^/}','{HASH;^/}','comments_form','comments_wrapper');

		var url_stem='{$FIND_SCRIPT;/,post_comment}?options={OPTIONS&;^/}&hash={HASH&;^/}';
		var wrapper=document.getElementById('comments_wrapper');
		if (wrapper)
			internalise_ajax_block_wrapper_links(url_stem,wrapper,['start_comments','max_comments'], { });

		{$,Infinite scrolling hides the pagination when it comes into view, and auto-loads the next link, appending below the current results}
		{+START,IF,{$NOT,{IS_THREADED}}}
			{+START,IF,{$CONFIG_OPTION,infinite_scrolling}}
				var infinite_scrolling_comments_wrapper=function (event) {
					var wrapper=document.getElementById('comments_wrapper');
					internalise_infinite_scrolling(url_stem,wrapper);
				};
				window.addEventListener('scroll',infinite_scrolling_comments_wrapper);
				window.addEventListener('keydown',infinite_scrolling_block);
				window.addEventListener('mousedown',infinite_scrolling_block_hold);
				window.addEventListener('mousemove',function() { infinite_scrolling_block_unhold(infinite_scrolling_comments_wrapper); }); // mouseup/mousemove does not work on scrollbar, so best is to notice when mouse moves again (we know we're off-scrollbar then)
				infinite_scrolling_comments_wrapper();
			{+END}
		{+END}
	});
//]]></script>
