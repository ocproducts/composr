{$REQUIRE_JAVASCRIPT,core_html_abstractions}
{$,This template is used for things like iframes used for previewing or for creating independent navigation areas in the site, or popups / overlays}
<!DOCTYPE html>
{$SET,is_preview,{$RUNNING_SCRIPT,preview}}
<html lang="{$LCASE*,{$LANG}}" dir="{!dir}" data-view="Global" data-tpl="standaloneHtmlWrap" data-tpl-params="{+START,PARAMS_JSON,is_preview}{_*}{+END}">
	<head>
		{+START,INCLUDE,HTML_HEAD}{+END}
	</head>

	<body class="{+START,IF_PASSED_AND_TRUE,FRAME}frame {+END}{+START,IF_PASSED_AND_TRUE,POPUP}popup_spacer {+END}{+START,IF_PASSED_AND_TRUE,OPENS_BELOW}opens_below {+END}website_body global_middle_faux{+START,IF_PASSED,CSS} {CSS*}{+END}" id="standalone_html_wrap" itemscope="itemscope" itemtype="http://schema.org/WebPage">
		{+START,IF_NON_PASSED_OR_FALSE,POPUP}
			{+START,IF_NON_EMPTY,{$MESSAGES_TOP}}
				<div class="global_messages">
					{$MESSAGES_TOP}
				</div>
			{+END}
		{+END}

		{CONTENT}

		{$JS_TEMPCODE}

		{+START,IF_NON_PASSED,POPUP}
			{$EXTRA_FOOT}
		{+END}
	</body>
</html>

