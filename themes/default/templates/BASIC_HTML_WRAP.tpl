{$,This template is used for very raw output like banner frames}
<!DOCTYPE html>

{$SET,page_link_privacy,{$PAGE_LINK,:privacy}}

<html lang="{$LCASE*,{$METADATA,lang}}"{$ATTR_DEFAULTED,dir,{!dir},ltr} data-view="Global" data-view-params="{+START,PARAMS_JSON,page_link_privacy}{_*}{+END}">
	<head>
		{$,The character set of the page}
		<meta http-equiv="Content-Type" content="text/html; charset={$CHARSET*}" />

		{+START,IF_PASSED,TARGET}<base href="{$BASE_URL*}/{$ZONE*}" target="{TARGET*}" />{+END}

		{+START,IF_PASSED_AND_TRUE,NOINDEX}
			<meta name="robots" content="noindex" />
		{+END}

		{$,Page title}
		<title>{+START,IF_NON_PASSED,TITLE}{+START,IF_NON_EMPTY,{$HEADER_TEXT}}{$HEADER_TEXT*} &ndash; {+END}{$SITE_NAME*}{+END}{+START,IF_PASSED,TITLE}{TITLE}{+END}</title>
	</head>

	<body class="website-body" id="basic-html-wrap" itemscope="itemscope" itemtype="http://schema.org/WebPage">
		<div>{CONTENT}</div>
	</body>
</html>
