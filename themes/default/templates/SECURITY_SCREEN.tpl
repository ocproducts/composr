{TITLE}

<h2>{!FAILED_LOGINS}</h2>

{FAILED_LOGINS}

<h2>{!SECURITY_ALERTS}</h2>

{+START,IF,{$JS_ON}}
	<p>
		{!SECURITY_PAGE_CLEANUP}
	</p>
{+END}

{ALERTS}

{+START,IF,{$NEQ,{NUM_ALERTS},0}}
	{+START,IF,{$JS_ON}}
		<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
			{$INSERT_SPAMMER_BLACKHOLE}

			<p class="proceed_button">
				<input onclick="if (add_form_marked_posts(this.form,'del_')) { disable_button_just_clicked(this); return true; } window.fauxmodal_alert('{!NOTHING_SELECTED=;}'); return false;" class="menu___generic_admin__delete button_screen" type="submit" value="{!DELETE}" />
			</p>
		</form>
	{+END}
{+END}
