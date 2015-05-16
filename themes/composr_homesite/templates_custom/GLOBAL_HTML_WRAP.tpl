<!DOCTYPE html>

<!--
Powered by {$BRAND_NAME*} version {$VERSION_NUMBER*}, (c) ocProducts Ltd
{$BRAND_BASE_URL*}
-->

{$,We deploy as HTML5 but code and conform strictly to XHTML5}
<html lang="{$LCASE*,{$LANG}}" dir="{!dir}">
<head>
	{+START,INCLUDE,HTML_HEAD}{+END}
</head>

{+START,IF,{$MOBILE}}
	{+START,INCLUDE,GLOBAL_HTML_WRAP_mobile}{+END}
{+END}

{+START,IF,{$NOT,{$MOBILE}}}
	{+START,INCLUDE,GLOBAL_HTML_WRAP_desktop}{+END}
{+END}

</html>
