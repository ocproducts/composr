{+START,IF_PASSED,PING_URL}{+START,IF_NON_EMPTY,{PING_URL}}
	<script>// <![CDATA[
		$(function() {
			do_ajax_request('{PING_URL;^/}');
			window.setInterval(function() { do_ajax_request('{PING_URL;^/}',function() {}); },12000);
		});
	//]]></script>
{+END}{+END}

