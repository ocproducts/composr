<blockquote class="box" data-toggleable-tray="{}">
	<h4 class="toggleable_tray_title js-tray-header">
		<a class="toggleable_tray_button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {$STRIP_TAGS,{TEXT}}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
		<a class="toggleable_tray_button js-tray-onclick-toggle-tray" href="#!">{TEXT}</a>
	</h4>

	<div class="toggleable_tray js-tray-content" style="display: none" aria-expanded="false">
		{CONTENT}
	</div>
</blockquote>
