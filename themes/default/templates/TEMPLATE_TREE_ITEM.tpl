<span class="vertical_alignment">
	<a {+START,IF_PASSED,GUID}title="GUID: {GUID*}" {+END}href="{EDIT_URL*}"><label for="f{ID*}file">{CODENAME*}</label></a>

	<input onclick="var e=document.getElementById('f{ID;}guid'); if (e) e.disabled=!this.checked;" type="checkbox" id="f{ID*}file" name="f{ID*}file" value="{FILE*}" />

	{+START,IF_PASSED,GUID}
		<input disabled="disabled" type="hidden" id="f{ID*}guid" name="f{ID*}guid" value="{GUID*}" />
	{+END}
</span>
