{+START,IF_NON_EMPTY,{$GET,support_mass_select}}
	<div class="mass_select_marker">
		<label class="accessibility_hidden" for="ms_{TYPE*}_{ID*}">{!SELECT} {TYPE*} #{ID*}</label>
		<input type="checkbox" name="_{TYPE*}_{ID*}" id="ms_{TYPE*}_{ID*}" onclick="prepare_mass_select_marker('{$GET;*,support_mass_select}','{TYPE;^*}','{ID;^*}',this.checked);" />
	</div>
{+END}
