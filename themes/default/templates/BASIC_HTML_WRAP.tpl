{$,This template is used for very raw output like banner frames}
<!DOCTYPE html>

<html lang="{$LCASE*,{$LANG}}" dir="{!dir}">
	<head>
		{$,The character set of the page}
		<meta http-equiv="Content-Type" content="text/html; charset={$CHARSET*}" />

		{$,Page title}
		<title>{+START,IF_NON_PASSED,TITLE}{+START,IF_NON_EMPTY,{$HEADER_TEXT}}{$HEADER_TEXT*} &ndash; {+END}{$SITE_NAME*}{+END}{+START,IF_PASSED,TITLE}{TITLE}{+END}</title>
	</head>

	<body class="website_body" id="basic_html_wrap" itemscope="itemscope" itemtype="http://schema.org/WebPage">
		<div>{CONTENT}</div>
	</body>
</html>

