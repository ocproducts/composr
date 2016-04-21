{+START,IF_NON_EMPTY,{AUTHORS}}
	<ul class="compact_list">
		{+START,LOOP,AUTHORS}
			<li>
				<a rel="nofollow" class="{$?,{DEFINED},author_defined,author_undefined}" href="#" onclick="var form=get_main_cms_window().document.getElementById('posting_form'); if (!form) form=get_main_cms_window().document.getElementById('main_form'); if (!form) { var forms=get_main_cms_window().document.getElementsByTagName('form'); form=forms[forms.length-1]; } var author=form.elements['{FIELD_NAME;*}']; author.value='{AUTHOR;*}'; window.faux_close();">{AUTHOR*}</a>
			</li>
		{+END}
	</ul>
{+END}
{+START,IF_EMPTY,{AUTHORS}}
	<p class="nothing_here">
		{!NO_ENTRIES,author}
	</p>
{+END}

{+START,IF_PASSED,NEXT_URL}
	<hr />

	<nav>
		<ul class="actions_list">
			<li><a title="{!MORE}: {!AUTHORS}" href="{NEXT_URL*}">{!MORE}</a></li>
		</ul>
	</nav>
{+END}
