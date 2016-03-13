<div class="float_surrounder {$CYCLE,tep,tpl_dropdown_row_a,tpl_dropdown_row_b}">
	<div class="left">
		<div class="accessibility_hidden"><label for="b_{FILE*}_{STUB*}">{STUB*}</label></div>
		<select name="b_{FILE*}_{STUB*}" id="b_{FILE*}_{STUB*}">
			<option>---</option>
			{PARAMETERS}
		</select>
	</div>
	{+START,IF,{$JS_ON}}
		<div class="right">
			<input class="button_micro menu___generic_admin__add_one" onclick="return template_insert_parameter('b_{FILE;*}_{STUB;*}','{FILE;*}');" type="button" value="{LANG*}" />
		</div>
	{+END}
</div>

