<h1>{NAME*}</h1>

<p>{!DOWNLOAD_IN_PROGRESS,{DOWNLOAD_URL*}}</p>

<div id="url_redirect_iframe">
	<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!DETAILS}" class="dynamic_iframe" src="{URL*}">{!DETAILS}</iframe>
</div>
