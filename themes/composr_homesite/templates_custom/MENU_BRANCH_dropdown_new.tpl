<li{+START,IF,{CURRENT}} class="active"{+END}>
	<a href="{URL*}">{CAPTION}</a>

	{+START,IF_NON_EMPTY,{CHILDREN}}
		<ul>
			{CHILDREN}
		</ul>
	{+END}
</li>
