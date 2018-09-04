{WRITTEN_CONTEXT}

{+START,IF_NON_EMPTY,{FOLLOWUP_URLS}}
	<ul class="horizontal-links">
		{+START,LOOP,FOLLOWUP_URLS}
			<li>
				<a href="{_loop_var*}"{+START,IF,{$NEQ,{_loop_key},{!VIEW}}} class="no-auto-tooltip"{+END}>{_loop_key*}</a>
			</li>
		{+END}
	</ul>
{+END}
