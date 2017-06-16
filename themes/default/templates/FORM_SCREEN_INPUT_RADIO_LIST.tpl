{$SET,early_description,1}

{+START,IF_PASSED,NAME}
	<div id="error_{NAME*}" style="display: none" class="input_error_here"></div>
{+END}

<div class="radio_list{+START,IF_PASSED_AND_TRUE,IMAGES} radio_list_pictures{+END}{+START,IF_PASSED_AND_TRUE,LINEAR} linear{+END}" data-tpl="formScreenInputRadioList" data-tpl-params="{+START,PARAMS_JSON,NAME,CODE}{_*}{+END}">
	{CONTENT}
</div>

{+START,IF_PASSED,NAME}
	{+START,IF,{REQUIRED}}
		<input type="hidden" name="require__{NAME*}" value="1" />
	{+END}
{+END}
