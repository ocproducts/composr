<li>
	<p>
		<a href="{URL*}">{LINK_CAPTION}</a>
	</p>

	<p>
		{DESCRIPTION}
	</p>

	{+START,IF_NON_EMPTY,{USAGE}}
		<p>
			<strong>{!BLOCK_USED_BY}</strong>:
			<span class="associated_details">{+START,LOOP,USAGE}{+START,IF,{$NEQ,{_loop_key},0}}, {+END}<kbd>{_loop_var*}</kbd>{+END}</span>
		</p>
	{+END}
</li>
