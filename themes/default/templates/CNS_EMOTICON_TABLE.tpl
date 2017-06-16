{$REQUIRE_JAVASCRIPT,core_cns}

<div data-tpl="cnsEmoticonTable">
	{+START,LOOP,ROWS}
		<div class="float_surrounder">
			{+START,LOOP,CELLS}
			<div class="cns_emoticon_cell" style="width: {$DIV*,100,{COLS}}%">
				<a href="#!" title="{!EMOTICON}: {CODE_ESC*}" class="js-click-do-emoticon" data-tp-field-name="{FIELD_NAME*}">
					<img src="{$IMG*,{THEME_IMG_CODE},1}" alt="{CODE*}" title="{CODE*}" />
				</a>
			</div>
			{+END}
		</div>
	{+END}
</div>
