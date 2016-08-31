{+START,IF_NON_EMPTY,{$GET,support_mass_select}}
	<div class="mass_select_marker" data-tpl-core="massSelectMarker" data-tpl-args="{+START,PARAMS_JSON,support_mass_select,TYPE,ID}{_*}{+END}">
		<label class="accessibility_hidden" for="ms_{TYPE*}_{ID*}">{!SELECT} {TYPE*} #{ID*}</label>
		<input type="checkbox" name="_{TYPE*}_{ID*}" id="ms_{TYPE*}_{ID*}" class="js-chb-prepare-mass-select" />
	</div>
{+END}
