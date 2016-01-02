<span class="vertical_alignment">
	<a{+START,IF_PASSED,GUID} title="{CODENAME*} GUID: {GUID*} {!LINK_NEW_WINDOW}"{+END}{+START,IF_NON_PASSED,GUID} title="{CODENAME*} {!LINK_NEW_WINDOW}"{+END} target="_blank" href="{EDIT_URL*}">{CODENAME*}</a>

	<label class="accessibility_hidden" for="f{ID*}file">{!SELECT}: {CODENAME*}</label>

	<input onclick="var e=document.getElementById('f{ID;*}guid'); if (e) e.disabled=!this.checked;" type="checkbox" id="f{ID*}file" name="f{ID*}file" value="{FILE*}" />

	{+START,IF_PASSED,GUID}
		<input disabled="disabled" type="hidden" id="f{ID*}guid" name="f{ID*}guid" value="{GUID*}" />
	{+END}
</span>
