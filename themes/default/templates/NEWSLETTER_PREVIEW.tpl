{$REQUIRE_JAVASCRIPT,newsletter}

<iframe id="preview_frame" name="preview_frame" title="{!PREVIEW}" class="hidden-preview-frame" src="{$BASE_URL*}/uploads/index.html" data-tpl="newsletterPreview" data-tpl-params="{+START,PARAMS_JSON,HTML_PREVIEW}{_*}{+END}" {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"}>{!PREVIEW}</iframe>
