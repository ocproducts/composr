{TITLE}

{WARNINGS}

{+START,IF_NON_EMPTY,{FILES}}
	<p class="lonely_label">{!WARNING_UNINSTALL}</p>
	<ul>
		{FILES}
	</ul>
{+END}

<div class="right">
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
		<input type="hidden" name="name" value="{NAME*}" />

		<p>
			{+START,IF,{$JS_ON}}
				<input class="buttons__back button_screen" type="button" onclick="history.back(); return false;" value="{!GO_BACK}" />
			{+END}

			<input class="menu___generic_admin__delete button_screen" type="submit" value="{!PROCEED}" />
		</p>
	</form>
</div>
