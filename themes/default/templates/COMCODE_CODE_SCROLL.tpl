<div class="comcode-code-wrap">
	<div class="comcode-code">
		<h4>{TITLE}</h4>

		{$SET,tag_type,{$?,{$IN_STR,{CONTENT},<div,<p,<table},div,{$?,{$EQ,{TYPE},samp},samp,code}}}
		<{$GET,tag_type} class="comcode-code-inner comcode-code-scroll">
			{CONTENT`}
		</{$GET,tag_type}>
	</div>
</div>
