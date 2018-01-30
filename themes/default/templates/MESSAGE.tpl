<div class="box box---message"><div class="box-inner">
	<div class="global-message" role="alert">
		<img width="24" height="24" src="{$IMG*,icons/48x48/status/{TYPE}}" alt="" />
		{+START,IF,{$IN_STR,{MESSAGE},<p}}
			{MESSAGE}
		{+END}
		{+START,IF,{$NOT,{$IN_STR,{MESSAGE},<p}}}
			<span>{MESSAGE}</span>
		{+END}
	</div>
</div></div>
