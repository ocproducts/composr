<div data-tpl="questionUiButtons">
	<h2>{TITLE*}</h2>

	{MESSAGE}

	<div class="question-ui-buttons">
		{+START,LOOP,BUTTONS}
			{+START,SET,IMG}{+OF,IMAGES,{_loop_key}}{+END}
			<a class="button-screen js-click-close-window-with-val" data-tp-return-value="{_loop_var*}" href="#!">{+START,IF,{$NOT,{$STARTS_WITH,{$GET,IMG},no_icon}}}{+START,INCLUDE,ICON}NAME={$GET,IMG}{+END}{+END} <span>{_loop_var*}</span></a>
		{+END}
	</div>
</div>
