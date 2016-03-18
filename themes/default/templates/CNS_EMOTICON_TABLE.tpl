{+START,LOOP,ROWS}
	<div class="float_surrounder">
		{+START,LOOP,CELLS}
			<div class="cns_emoticon_cell" style="width: {$DIV*,100,{COLS}}%">
				<a href="#" title="{!EMOTICON}: {CODE_ESC*}" onclick="do_emoticon('{FIELD_NAME;*}',this,true); return false;"><img src="{$IMG*,{THEME_IMG_CODE},1}" alt="{CODE*}" title="{CODE*}" /></a>
			</div>
		{+END}
	</div>
{+END}
