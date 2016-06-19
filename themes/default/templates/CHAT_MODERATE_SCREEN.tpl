{TITLE}

{+START,IF_NON_EMPTY,{INTRODUCTION}}<p>{INTRODUCTION}</p>{+END}

{CONTENT}

{+START,IF,{$JS_ON}}{+START,IF_PASSED,URL}
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
		<p class="proceed_button">
			<input onclick="if (add_form_marked_posts(this.form,'del_')) { disable_button_just_clicked(this); return true; } window.fauxmodal_alert('{!NOTHING_SELECTED=;}'); return false;" class="button_screen menu___generic_admin__delete" type="submit" value="{!DELETE}" />
		</p>
	</form>
{+END}{+END}

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
