{$REQUIRE_JAVASCRIPT,core_themeing}

<span class="vertical_alignment" data-tpl="templateTreeItem">
	<a{+START,IF_PASSED,GUID} title="{CODENAME*} GUID: {GUID*} {!LINK_NEW_WINDOW}"{+END}{+START,IF_NON_PASSED,GUID} title="{CODENAME*} {!LINK_NEW_WINDOW}"{+END} target="_blank" href="{EDIT_URL*}">{CODENAME*}</a>

	<label class="accessibility_hidden" for="f__id__file">{!SELECT}: {CODENAME*}</label>

	<input class="js-click-checkbox-toggle-guid-input" type="checkbox" id="f__id__file" name="f__id__file" value="{FILE*}" />

	{+START,IF_PASSED,GUID}
		<input disabled="disabled" type="hidden" id="f__id__guid" name="f__id__guid" value="{GUID*}" />
	{+END}
</span>
