<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" onsubmit="return submit_settings(this);">
	{HIDDEN}

	<div>
		<div class="installer_main_min">
			{MESSAGE}

			{SECTIONS}
		</div>

		<p class="proceed_button">
			<input class="buttons__proceed button_screen" type="submit" value="{!INSTALL} Composr" />
		</p>
	</div>
</form>

{+START,IF_PASSED,JS}
	<script>// <![CDATA[
		{JS/}

		var domain=document.getElementById('domain');
		if (domain)
		{
			domain.onchange=function() {
				var cs=document.getElementById('Cookie_space_settings');
				if ((cs) && (cs.style.display=='none')) toggle_section('Cookie_space_settings');
				var cd=document.getElementById('cookie_domain');
				if ((cd) && (cd.value!='')) cd.value='.'+domain.value;
			}
		}
	//]]></script>
{+END}
