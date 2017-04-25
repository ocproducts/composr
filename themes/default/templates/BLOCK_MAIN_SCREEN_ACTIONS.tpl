{$REQUIRE_JAVASCRIPT,recommend}
<aside class="screen_actions_outer box" data-tpl="blockMainScreenActions" data-tpl-params="{+START,PARAMS_JSON,EASY_SELF_URL}{_*}{+END}"><nav class="screen_actions box_inner">
	<div class="print"><a class="link_exempt" rel="print nofollow" target="_blank" title="{!PRINT_THIS_SCREEN} {!LINK_NEW_WINDOW}" href="{PRINT_URL*}"><span>{!PRINT_THIS_SCREEN}</span></a></div>
	<div class="recommend"><a data-open-as-overlay="1" class="link_exempt" rel="nofollow" target="_blank" title="{!RECOMMEND_LINK} {!LINK_NEW_WINDOW}" href="{RECOMMEND_URL*}"><span>{!RECOMMEND_LINK}</span></a></div>
	<div class="facebook"><a class="link_exempt" target="_blank" title="{!ADD_TO_FACEBOOK} {!LINK_NEW_WINDOW}" href="http://www.facebook.com/sharer.php?u={EASY_SELF_URL*}"><span>{!ADD_TO_FACEBOOK}</span></a></div>
	<div class="twitter"><a class="link_exempt js-click-action-add-to-twitter" target="_blank" title="{!ADD_TO_TWITTER} {!LINK_NEW_WINDOW}" href="http://twitter.com/home?status=RT%20{EASY_SELF_URL*}"><span>{!ADD_TO_TWITTER}</span></a></div>
	<div class="stumbleupon"><a class="link_exempt" target="_blank" title="{!ADD_TO_STUMBLEUPON} {!LINK_NEW_WINDOW}" href="http://www.stumbleupon.com/submit?url={EASY_SELF_URL*}"><span>{!ADD_TO_STUMBLEUPON}</span></a></div>
	<div class="digg"><a class="link_exempt" target="_blank" title="{!ADD_TO_DIGG} {!LINK_NEW_WINDOW}" href="http://digg.com/submit?phase=2&amp;url={EASY_SELF_URL*}"><span>{!ADD_TO_DIGG}</span></a></div>

	<div class="google_plusone">
		<div class="g-plusone" data-size="medium" data-count="true" data-href="{EASY_SELF_URL*}"></div>
		{$EXTRA_FOOT,<script {$CSP_NONCE_HTML} defer src="https://apis.google.com/js/plusone.js"></script>}
	</div>
</nav></aside>
