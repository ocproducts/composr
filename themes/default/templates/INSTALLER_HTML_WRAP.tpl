<!DOCTYPE html>
<html lang="{$LCASE*,{$LANG}}" dir="{!dir}" data-view="Global">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset={$CHARSET*}" />
		<meta name="GENERATOR" content="Composr" />
		<meta name="description" content="Composr installer" />
		<link rel="icon" href="{$BRAND_BASE_URL*}/favicon.ico" type="image/x-icon" />
		<link {$CSP_NONCE_HTML} href="{CSS_URL*}" rel="stylesheet" />
		<link {$CSP_NONCE_HTML} href="{CSS_URL_2*}" rel="stylesheet" />
		<style {$CSP_NONCE_HTML}>
			{CSS_NOCACHE*}
		</style>
		<title>{!INSTALLER,Composr}</title>

		<meta name="robots" content="noindex, nofollow" />
		
		<!-- Required for $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular script has been already loaded -->
		<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/log-loaded-scripts.js"></script>

		{$,Load classList and ES6 Promise polyfill for Internet Explorer LEGACY}
		{+START,IF,{$BROWSER_MATCHES,ie}}
		<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/class-list.js"></script>
		<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/promise.js"></script>
		<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/custom-event-constructor.js"></script>
		{+END}

		{$,Polyfills for everyone LEGACY}
		<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/general.js"></script>
		<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/url-search-params.max.js"></script>
		<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/keyboardevent-key-polyfill.js"></script>
		<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/fetch.js"></script>
		<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/web-animations.min.js"></script>
		<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/json5.js"></script>
		
		<script {$CSP_NONCE_HTML}>
			window.IN_MINIKERNEL_VERSION = true;
			/*{+START,INCLUDE,PASSWORD_CHECK_JS}INSTALLER=1{+END}*/
		</script>
	</head>

	<body id="installer_body" class="website_body" data-tpl="installerHtmlWrap" data-tpl-params="{+START,PARAMS_JSON,DEFAULT_FORUM}{_*}{+END}">
		<div class="installer_main">
			<img alt="Composr" src="{LOGO_URL*}" width="550" height="115" />
		</div>

		<div class="installer_main_inner">
			<div class="box box___installer_html_wrap"><div class="box_inner">
				<h1>{!INSTALLER,Composr}: {!INSTALLER_STEP,{STEP},10}</h1>

				<div id="extra_errors"></div>

				<div>
					{CONTENT}
				</div>
			</div></div>
		</div>

		<div class="installer_version">
			<p>
				{!VERSION_NUM,{VERSION}}
				<br />
				Composr, {!CREATED_BY,ocProducts}
			</p>
			<p>
				<a target="_blank" title="compo.sr {!LINK_NEW_WINDOW}" href="{$BRAND_BASE_URL*}">{$BRAND_BASE_URL*}</a>
			</p>
		</div>
	
		<script>
			{GLOBAL_JS/}
		</script>
	</body>
</html>
