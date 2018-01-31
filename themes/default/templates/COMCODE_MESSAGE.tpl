{$REQUIRE_JAVASCRIPT,core_rich_media}

<div class="comcode-supported block-desktop" data-tpl="comcodeMessage" data-tpl-params="{+START,PARAMS_JSON,NAME}{_*}{+END}">
	<input type="hidden" name="comcode__{NAME*}" value="1" />

	<ul class="horizontal-links horiz-field-sep">
		{+START,IF,{$SHOW_DOCS}}{+START,IF_PASSED,URL}
			<li><a data-open-as-overlay="{}" class="link-exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{URL*}"><img width="16" height="16" src="{$IMG*,icons/editor/comcode}" class="vertical-alignment" alt="{!COMCODE_MESSAGE,Comcode}" /></a></li>
		{+END}{+END}
		<li><a rel="nofollow" class="link-exempt js-link-click-open-emoticon-chooser-window" data-click-pd="1" title="{!EMOTICONS_POPUP} {!LINK_NEW_WINDOW}" target="_blank" href="{$FIND_SCRIPT*,emoticons}?field_name={NAME*}{$KEEP*,0,1}"><img width="16" height="16" src="{$IMG*,icons/editor/insert_emoticons}" alt="{!EMOTICONS_POPUP}" class="vertical-alignment" /></a></li>

		{+START,IF,{W}}
			<li><a rel="nofollow" id="toggle_wysiwyg_{NAME*}" href="#!" class="js-click-toggle-wysiwyg"><abbr title="{!comcode:TOGGLE_WYSIWYG_2}"><img width="16" height="16" src="{$IMG*,icons/editor/wysiwyg_on}" alt="{!comcode:ENABLE_WYSIWYG}" title="{!comcode:ENABLE_WYSIWYG}" class="vertical-alignment" /></abbr></a></li>
		{+END}
	</ul>
</div>
