<h3>{TITLE*}</h3>

<div class="box" data-toggleable-tray="{}">
	<h4 class="toggleable_tray_title js-tray-header">
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" title="{!SETTINGS}: {!EXPAND}" href="#!"><img alt="{!EXPAND}: {TITLE*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" /></a>
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" title="{!SETTINGS}: {!EXPAND}" href="#!">{!SETTINGS}</a>
	</h4>
	<div class="toggleable_tray js-tray-content" style="display: none" aria-expanded="false">
		{FORM}
	</div>
</div>
