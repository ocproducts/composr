{$REQUIRE_JAVASCRIPT,facebook_support}

<aside class="screen-actions-outer box" data-require-javascript="facebook_support" data-tpl="blockMainScreenActions" data-tpl-params="{+START,PARAMS_JSON,EASY_SELF_URL}{_*}{+END}">
<nav class="screen_actions box-inner">
	{+START,IF_NON_EMPTY,{$CONFIG_OPTION,facebook_appid}}
		<div class="facebook_like"><div class="fb-like" data-send="false" data-layout="button_count" data-width="55" data-show-faces="false"></div></div>
	{+END}
	<div class="print"><a class="link-exempt js-click-print-screen" rel="print nofollow" target="_blank" title="{!PRINT_THIS_SCREEN} {!LINK_NEW_WINDOW}" href="{PRINT_URL*}"><span>{!PRINT_THIS_SCREEN}</span></a></div>
	<div class="recommend"><a data-open-as-overlay="{}" class="link-exempt" rel="nofollow" target="_blank" title="{!RECOMMEND_LINK} {!LINK_NEW_WINDOW}" href="{RECOMMEND_URL*}"><span>{!RECOMMEND_LINK}</span></a></div>
	{+START,IF_EMPTY,{$CONFIG_OPTION,facebook_appid}}
		<div class="facebook"><a class="link-exempt js-click-add-to-facebook" target="_blank" title="{!ADD_TO_FACEBOOK} {!LINK_NEW_WINDOW}" href="http://www.facebook.com/sharer.php?u={EASY_SELF_URL*}"><span>{!ADD_TO_FACEBOOK}</span></a></div>
	{+END}
	<div class="twitter"><a class="link-exempt js-click-add-to-twitter" target="_blank" title="{!ADD_TO_TWITTER} {!LINK_NEW_WINDOW}" href="http://twitter.com/home?status=RT%20{EASY_SELF_URL*}"><span>{!ADD_TO_TWITTER}</span></a></div>
	<div class="stumbleupon"><a class="link-exempt js-click-add-to-stumbleupon" target="_blank" title="{!ADD_TO_STUMBLEUPON} {!LINK_NEW_WINDOW}" href="http://www.stumbleupon.com/submit?url={EASY_SELF_URL*}"><span>{!ADD_TO_STUMBLEUPON}</span></a></div>
	<div class="digg"><a class="link-exempt js-click-add-to-digg" target="_blank" title="{!ADD_TO_DIGG} {!LINK_NEW_WINDOW}" href="http://digg.com/submit?phase=2&amp;url={EASY_SELF_URL*}"><span>{!ADD_TO_DIGG}</span></a></div>

	<div class="google_plusone">
		<div class="g-plusone" data-size="medium" data-count="true" data-href="{EASY_SELF_URL*}" data-callback="$cms.googlePlusTrack"></div>
		{$EXTRA_FOOT,<script {$CSP_NONCE_HTML} src="https://apis.google.com/js/plusone.js"></script>}
	</div>
</nav>
</aside>
