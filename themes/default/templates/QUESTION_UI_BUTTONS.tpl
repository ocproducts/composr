<h2>{TITLE*}</h2>

{MESSAGE}

<div class="question_ui_buttons">
	{+START,LOOP,BUTTONS}
		{+START,SET,IMG}{+OF,IMAGES,{_loop_key}}{+END}
		<a class="{$GET,IMG} button_screen" href="#" onclick="window.returnValue='{_loop_var;*}'; if (typeof window.faux_close!='undefined') window.faux_close(); else { try { window.get_main_cms_window().focus(); } catch (e) {} window.close(); }"><span>{_loop_var*}</span></a>
	{+END}
</div>
