<div class="comcode-code-wrap">
	<div class="comcode-code">
		<h4>{TITLE}</h4>

		{$SET,tag_type,{$?,{$IN_STR,{CONTENT},<div,<p,<table},div,{$?,{$EQ,{TYPE},samp},samp,code}}}
		<div class="webstandards-checker-off"><{$GET,tag_type} class="comcode-code-inner">{CONTENT`}</{$GET,tag_type}></div>
	</div>
</div>
