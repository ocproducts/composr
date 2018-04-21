<blockquote class="box" data-toggleable-tray="{}">
	<h4 class="toggleable-tray-title js-tray-header">
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!" title="{!EXPAND}">
			{+START,INCLUDE,ICON}
				NAME=trays/expand
				ICON_SIZE=24
			{+END}
		</a>
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{TEXT}</a>
	</h4>

	<div class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
		{CONTENT}
	</div>
</blockquote>
