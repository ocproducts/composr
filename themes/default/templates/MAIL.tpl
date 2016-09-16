{$,It is advisable to edit this MAIL template in the default theme, as this will ensure that all mail sent from the website will be formatted consistently, whatever theme happens to be running at the time}

<!DOCTYPE html>
<html lang="{$LCASE*,{$LANG}}" dir="{!dir}">
<head>
<meta http-equiv="Content-Type" content="text/html; charset={$CHARSET*}" />
<title>{TITLE*}</title>
{CSS}
</head>
<body style="font-size: 12px" class="email_body">
	<div style="font-size: 12px" class="email_body">
		<p class="email_logo">
			<a href="{$BASE_URL*}"><img src="{$IMG*,logo/standalone_logo}" title="{$SITE_NAME*}" alt="{$SITE_NAME*}" /></a>
		</p>

		<div class="box box___mail"><div class="box_inner">
			<div>
				<h2>{TITLE*}</h2>

				{CONTENT}
			</div>
		</div></div>

		<hr class="spaced_rule" />

		<div class="email_footer">
			<div class="email_copyright">
				{$COPYRIGHT`}
			</div>

			<div class="email_url">
				{$PREG_REPLACE*,^.*://,,{$BASE_URL}}
			</div>
		</div>
		<br clear="all" />
	</div>
</body>
</html>

