{TITLE}

{WARNINGS}

{+START,IF_NON_EMPTY,{FILES}}
	<p class="lonely_label">{!WARNING_UNINSTALL}</p>
	<ul>
		{FILES}
	</ul>
{+END}

<div class="right">
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<input type="hidden" name="name" value="{NAME*}" />

		<p>
			{+START,IF,{$JS_ON}}
				<input class="button_screen buttons__back" type="button" onclick="history.back(); return false;" value="{!GO_BACK}" />
			{+END}

			<input class="button_screen menu___generic_admin__delete" type="submit" value="{!PROCEED}" />
		</p>
	</form>
</div>
