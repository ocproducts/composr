{TITLE}

<p>{!DOWNLOAD_IN_PROGRESS,{DOWNLOAD_URL*}}</p>

<div id="url-redirect-iframe">
	<iframe {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!DETAILS}" name="download-interstitial" id="download-interstitial" class="dynamic-iframe" src="{URL*}">{!DETAILS}</iframe>
</div>
