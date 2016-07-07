{+START,IF_PASSED,PRIORITY}
	<tr>
		<td colspan="3">
			<h2>{PRIORITY*}</h2>
		</td>
	</tr>
{+END}
<tr{+START,IF_PASSED_AND_TRUE,LAST} class="last"{+END}>
	<td class="translate_line_first">
		{NAME*}
	</td>
	<td class="translate_line_second">
		<div class="accessibility_hidden"><label for="old__trans_{NAME*}">{!OLD} {NAME*}</label></div>
		<div class="constrain_field">
			<textarea readonly="readonly" class="translate_original_text wide_field" cols="60" rows="{$ADD*,{$DIV,{$LENGTH,{OLD}},80},1}" id="old__trans_{NAME*}" name="old__{NAME*}">{OLD*}</textarea>
		</div>

		<div class="arrow_ruler"><img alt="" src="{$IMG*,arrow_ruler_small}" /></div>

		<div class="accessibility_hidden"><label for="trans_{ID*}">{NAME*}</label></div>
		<div class="constrain_field">
			<textarea class="wide_field translate_field" cols="60" rows="{$ADD*,{$DIV,{$LENGTH,{CURRENT}},80},1}" id="trans_{ID*}" name="trans_{ID*}">{CURRENT*}</textarea>
		</div>
	</td>
	<td>
		{ACTIONS}
	</td>
</tr>
<tr id="rexp_trans_{ID*}" style="display: none">
	<td colspan="{$?,{$IS_EMPTY,{ACTIONS}},3,4}">
		<div id="exp_trans_{ID*}"></div>
	</td>
</tr>
