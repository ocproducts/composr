<p>
	{!ADVANCED_BELOW}
</p>

<p class="lonely_label">
	<a class="toggleable_tray_button" href="#" onclick="toggle_section('{TITLE;~|*}'); return false;">{TITLE}</a> <a class="toggleable_tray_button" href="#" onclick="toggle_section('{TITLE;~|*}'); return false;"><img id="img_{TITLE|*}" alt="{!EXPAND}: {$STRIP_TAGS,{TITLE}}" title="{!EXPAND}" src="{$BASE_URL*}/install.php?type=expand" /></a>
</p>

<div id="{TITLE|*}" style="display: {$JS_ON,none,block}">
	{CONTENT}
</div>
