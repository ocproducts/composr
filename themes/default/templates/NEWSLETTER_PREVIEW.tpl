{$REQUIRE_JAVASCRIPT,newsletter}

<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} id="preview_frame" name="preview_frame" title="{!PREVIEW}" class="hidden_preview_frame" src="{$BASE_URL*}/uploads/index.html">{!PREVIEW}</iframe>

<noscript>
	{HTML_PREVIEW*}
</noscript>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		newsletter_preview_into('preview_frame','{HTML_PREVIEW;^/}');
	});
//]]></script>
