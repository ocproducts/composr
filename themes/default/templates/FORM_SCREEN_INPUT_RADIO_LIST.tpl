{$SET,early_description,1}

{+START,IF_PASSED,NAME}
	<div id="error_{NAME*}" style="display: none" class="input_error_here"></div>
{+END}

<div class="radio_list" data-tpl="formScreenInputRadioList" data-tpl-args="{+START,PARAMS_JSON,NAME,CODE}{_*}{+END}">
	{CONTENT}
</div>

{+START,IF_PASSED,NAME}
{+START,IF,{REQUIRED}}
	<input type="hidden" name="require__{NAME*}" value="1" />
{+END}
{+END}