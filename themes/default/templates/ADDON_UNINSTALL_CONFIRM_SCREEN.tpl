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
			<input class="button_screen buttons__back" type="button" data-cms-btn-go-back="1" value="{!GO_BACK}" />

			<input class="button_screen menu___generic_admin__delete" type="submit" value="{!PROCEED}" />
		</p>
	</form>
</div>
