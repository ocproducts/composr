<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset={$CHARSET*}" />
<title>{TITLE*}</title>
{CSS}
</head>

<body style="margin:0; font-family:'Trebuchet MS', Arial, Helvetica, sans-serif; font-size:13px;" class="email_body">
<div style="background:#fff;" class="email_body">
	<div style="padding:5px; background:#fff;" class="email_logo"><a href="{$BASE_URL*}"><img alt="Composr logo" src="{$IMG*,logo/standalone_logo}" /></a></div>

	<div style="padding:5px; background:#fff;">
		<h2 style="color:#f9a339; font-size:20px; margin:0; padding-bottom:15px; border-bottom:#ccc solid 1px;">{TITLE*}</h2>

		<div style="line-height:22px; color:#666; font-size:14px; padding-bottom:20px; border-bottom:#f9a339 solid 7px; margin-top:10px; margin-bottom:2px;">
			{CONTENT}
		</div>

		<div style="padding-top:30px; padding-bottom:25px; border-top:#f9a339 solid 1px; color:#666;">
			<span style="text-align:left; float:left;">{$COPYRIGHT`}</span>
			<span style="float:right;">Composr CMS</span>
		</div>
	</div>
</div>
</body>
</html>
