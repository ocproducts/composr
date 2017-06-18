{$REQUIRE_JAVASCRIPT,chat}

<div data-tpl="chatModerateScreen">
	{TITLE}

	{+START,IF_NON_EMPTY,{INTRODUCTION}}<p>{INTRODUCTION}</p>{+END}

	{CONTENT}

	{+START,IF_PASSED,URL}
		<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
			<p class="proceed_button">
				<input class="button_screen menu___generic_admin__delete js-click-btn-delete-marked-posts" type="submit" value="{!DELETE}" />
			</p>
		</form>
	{+END}

	{+START,IF_NON_EMPTY,{LINKS}}
		<hr class="spaced_rule" />

		<p class="lonely_label">{!ACTIONS}:</p>
		<nav>
			<ul class="actions_list">
				{+START,LOOP,LINKS}
					<li>{_loop_var}</li>
				{+END}
			</ul>
		</nav>
	{+END}
</div>
