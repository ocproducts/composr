{$,This template is used for things like iframes used for previewing or for creating independent navigation areas in the site}
<!DOCTYPE html>

<html lang="{$LCASE*,{$LANG}}" dir="{!dir}">
	<head>
		{+START,INCLUDE,HTML_HEAD}TITLE={!MESSAGES}{+END}

		<meta http-equiv="Refresh" content="30; URL={$FIND_SCRIPT*,wmessages}{$KEEP*,1}" />
	</head>

	<body class="website_body" style="background: transparent" id="basic_html_wrap" itemscope="itemscope" itemtype="http://schema.org/WebPage">
		{MESSAGES}
	</body>
</html>
