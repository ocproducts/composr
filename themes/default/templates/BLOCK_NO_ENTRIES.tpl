<section class="box box___block_no_entries_{$LCASE|,{TITLE}}"><div class="box-inner">
	{+START,IF_NON_EMPTY,{TITLE}}
		<h3>{TITLE*}</h3>
	{+END}

	<p class="nothing-here">{MESSAGE*}</p>

	{+START,IF_PASSED,SUBMIT_URL}{+START,IF_NON_EMPTY,{SUBMIT_URL}}
		<ul class="horizontal-links associated-links-block-group">
			<li><a target="_top" href="{SUBMIT_URL*}">{ADD_NAME*}</a></li>
		</ul>
	{+END}{+END}
</div></section>
