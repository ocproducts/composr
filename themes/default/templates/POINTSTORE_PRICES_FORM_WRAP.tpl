<h3>{TITLE*}</h3>

<div class="box">
	<h4 class="toggleable_tray_title">
		<a class="toggleable_tray_button" title="{!SETTINGS}: {!EXPAND}" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {TITLE*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a> <a class="toggleable_tray_button" title="{!SETTINGS}: {!EXPAND}" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{!SETTINGS}</a>
	</h4>
	<div class="toggleable_tray" style="display: {$JS_ON,none,block}" aria-expanded="false">
		{FORM}
	</div>
</div>

