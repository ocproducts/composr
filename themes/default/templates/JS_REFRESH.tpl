<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		if (window.location.hash.indexOf('redirected_once') == -1)
		{
			window.location.hash='redirected_once';
			document.getElementById('{FORM_NAME;/}').submit();
		} else
		{
			window.history.go(-2); // We've used back button, don't redirect forward again
		}
	});
//]]></script>
