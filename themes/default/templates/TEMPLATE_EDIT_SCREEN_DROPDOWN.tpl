<div class="float_surrounder {$CYCLE,tep,tpl_dropdown_row_a,tpl_dropdown_row_b}">
	<div class="left">
		<div class="accessibility_hidden"><label for="f{ID*}{NAME*}">{NAME*}</label></div>
		<select name="f{ID*}{NAME*}" id="f{ID*}{NAME*}">
			<option>---</option>
			{PARAMETERS}
		</select>
	</div>
	{+START,IF,{$JS_ON}}
		<div class="right">
			<input class="button_micro menu___generic_admin__add_one" name="f{ID*}dd_{NAME*}" onclick="return template_edit_page('f{ID;*}{NAME;*}','{ID;*}');" type="button" value="{LANG*}" />
		</div>
	{+END}
</div>

