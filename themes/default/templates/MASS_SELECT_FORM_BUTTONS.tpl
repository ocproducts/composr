{$SET,action_url,{$PAGE_LINK,_SELF:_SELF:mass_delete}}
{+START,IF,{$JS_ON}}
	<input type="button" id="mass_select_button" disabled="disabled"
		   class="button_screen menu___generic_admin__delete js-btn-mass-delete" value="{!DELETE_SELECTION}"
		   data-tpl="massSelectFormButtons" data-tpl-params="{+START,PARAMS_JSON,action_url,TYPE}{_*}{+END}" />
{+END}