<p>
	{!SUCCESS_UPLOAD_SYNDICATION_AUTH,{LABEL*}}
</p>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		var win_parent=window.parent;
		if (!win_parent) win_parent=window.opener;

		var ob=win_parent.document.getElementById('upload_syndicate__{HOOK;/}__{NAME;/}');
		ob.checked=true;

		var win=window;
		window.setTimeout(function() {
			if (typeof win.faux_close!='undefined')
				win.faux_close();
			else
				win.close();
		}, 4000);
	});
//]]></script>
