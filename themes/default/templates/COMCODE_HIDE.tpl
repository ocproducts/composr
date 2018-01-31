<blockquote class="box" data-toggleable-tray="{}">
	<h4 class="toggleable-tray-title js-tray-header">
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {$STRIP_TAGS,{TEXT}}" title="{!EXPAND}" width="24" height="24" src="{$IMG*,icons/trays/expand2}" /></a>
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{TEXT}</a>
	</h4>

	<div class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
		{CONTENT}
	</div>
</blockquote>
