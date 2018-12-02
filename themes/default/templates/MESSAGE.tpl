<div class="box box---message box---message-{TYPE*}"><div class="box-inner">
	<div class="global-message" role="alert">
		{+START,INCLUDE,ICON}
			NAME=status/{TYPE}
			ICON_SIZE=24
		{+END}

		{+START,IF,{$IN_STR,{MESSAGE},<p}}
			{MESSAGE}
		{+END}
		{+START,IF,{$NOT,{$IN_STR,{MESSAGE},<p}}}
			<span>{MESSAGE}</span>
		{+END}
	</div>
</div></div>
