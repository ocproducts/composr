{+START,IF_PASSED,PRIORITY}
	<tr>
		<td colspan="{$?,{$IS_EMPTY,{ACTIONS}},2,3}">
			<h2>{PRIORITY*}</h2>
		</td>
	</tr>
{+END}
<tr {+START,IF_PASSED_AND_TRUE,LAST} class="last"{+END}>
	<td class="translate-line-first">
		{NAME*}
	</td>
	<td class="translate-line-second">
		<div class="accessibility-hidden"><label for="old--trans-{NAME*}">{!OLD} {NAME*}</label></div>
		<div>
			<textarea readonly="readonly" class="translate-original-text form-control form-control-wide" cols="60" rows="{$ADD*,{$DIV,{$LENGTH,{OLD}},80},1}" id="old--trans-{NAME*}" name="old__{NAME*}">{OLD*}</textarea>
		</div>

		<div class="arrow-ruler"><img alt="" width="36" height="36" src="{$IMG*,arrow_ruler}" /></div>

		<div class="accessibility-hidden"><label for="trans-{ID*}">{NAME*}</label></div>
		<div>
			<textarea class="form-control form-control-wide translate-field" cols="60" rows="{$ADD*,{$DIV,{$LENGTH,{CURRENT}},80},1}" id="trans-{ID*}" name="trans_{ID*}">{CURRENT*}</textarea>
		</div>
	</td>
	{+START,IF_NON_EMPTY,{ACTIONS}}
		<td>
			{ACTIONS}
		</td>
	{+END}
</tr>
{+START,IF_NON_EMPTY,{ACTIONS}}
	<tr id="rexp-trans-{ID*}" style="display: none">
		<td colspan="{$?,{$IS_EMPTY,{ACTIONS}},3,4}">
			<div id="exp-trans-{ID*}"></div>
		</td>
	</tr>
{+END}
