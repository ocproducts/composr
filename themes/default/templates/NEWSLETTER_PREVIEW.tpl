{$REQUIRE_JAVASCRIPT,newsletter}

<iframe id="preview_frame" name="preview_frame" title="{!PREVIEW}" class="hidden_preview_frame" src="{$BASE_URL*}/uploads/index.html" data-tpl="newsletterPreview" data-tpl-args="{+START,PARAMS_JSON,HTML_PREVIEW}{_*}{+END}" {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"}>{!PREVIEW}</iframe>

<noscript>
	{HTML_PREVIEW*}
</noscript>
