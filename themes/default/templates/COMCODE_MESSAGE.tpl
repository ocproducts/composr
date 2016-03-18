<div class="comcode_supported">
	<input type="hidden" name="comcode__{NAME*}" value="1" />

	<ul class="horizontal_links horiz_field_sep">
		{+START,IF,{$SHOW_DOCS}}{+START,IF_PASSED,URL}
			<li><a onclick="return open_link_as_overlay(this);" class="link_exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{URL*}"><img src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" class="vertical_alignment" alt="" /></a></li>
		{+END}{+END}
		<li><a rel="nofollow" class="link_exempt" title="{!EMOTICONS_POPUP} {!LINK_NEW_WINDOW}" target="_blank" href="{$FIND_SCRIPT*,emoticons}?field_name={NAME*}{$KEEP*,0,1}" onclick="window.faux_open(maintain_theme_in_link('{$FIND_SCRIPT;*,emoticons}?field_name={NAME;*}{$KEEP;*,0,1}'),'field_emoticon_chooser','width=300,height=320,status=no,resizable=yes,scrollbars=no'); return false;"><img src="{$IMG*,icons/16x16/editor/insert_emoticons}" srcset="{$IMG*,icons/32x32/editor/insert_emoticons} 2x" alt="" class="vertical_alignment" /></a></li>

		{+START,IF,{$AND,{$JS_ON},{W}}}
			<li><a rel="nofollow" id="toggle_wysiwyg_{NAME*}" href="#" onclick="return toggle_wysiwyg('{NAME;*}');"><abbr title="{!comcode:TOGGLE_WYSIWYG_2}"><img src="{$IMG*,icons/16x16/editor/wysiwyg_on}" srcset="{$IMG*,icons/32x32/editor/wysiwyg_on} 2x" alt="{!comcode:ENABLE_WYSIWYG}" title="{!comcode:ENABLE_WYSIWYG}" class="vertical_alignment" /></abbr></a></li>
		{+END}
	</ul>
</div>
