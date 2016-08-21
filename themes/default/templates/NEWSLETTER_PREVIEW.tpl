{$REQUIRE_JAVASCRIPT,newsletter}

<iframe id="preview_frame" name="preview_frame" title="{!PREVIEW}" class="hidden_preview_frame" src="{$BASE_URL*}/uploads/index.html" data-cms-call="newsletter_preview_into" data-cms-call-args='["preview_frame", "{HTML_PREVIEW*#"]' {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"}>{!PREVIEW}</iframe>

<noscript>
	{HTML_PREVIEW*}
</noscript>
