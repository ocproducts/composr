<div data-tpl="questionUiButtons">
	<h2>{TITLE*}</h2>

	{MESSAGE}

	<div class="question-ui-buttons">
		{+START,LOOP,BUTTONS}
			{+START,SET,IMG}{+OF,IMAGES,{_loop_key}}{+END}
			<a class="{$GET,IMG} button_screen js-click-close-window-with-val" data-tp-return-value="{_loop_var*}" href="#!"><span>{_loop_var*}</span></a>
		{+END}
	</div>
</div>
