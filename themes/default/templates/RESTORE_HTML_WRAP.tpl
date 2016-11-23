<!DOCTYPE html>

<html lang="{$LCASE*,{$LANG}}" dir="{!dir}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset={$CHARSET*}" />
		<link href="restore.php?type=css" rel="stylesheet" />
		{+START,IF_NON_EMPTY,{CSS_NOCACHE}}
			<style>/*<![CDATA[*/
				{CSS_NOCACHE*}
			/*]]>*/</style>
		{+END}
		<title>Backup restorer</title>
	</head>

	<body id="installer_body" class="website_body">
		<div class="installer_main">
			<img alt="Composr" src="{$BASE_URL*}/themes/default/images/EN/logo/standalone_logo.png" />
		</div>

		<div class="installer_main_inner">
			<div class="box box___restore_html_wrap"><div class="box_inner">
				{+START,IF_NON_PASSED_OR_FALSE,ERROR}
					<h1>Restoring the website</h1>
				{+END}

				{MESSAGE}
			</div></div>
		</div>
	</body>
</html>


