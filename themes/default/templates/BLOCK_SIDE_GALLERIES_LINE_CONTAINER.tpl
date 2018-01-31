{+START,IF_NON_EMPTY,{CONTENTS}}
	<div data-toggleable-tray="{}">
		<span class="side-galleries-block-exp toggleable-tray-title js-tray-header">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {CAPTION*}" title="{!EXPAND}" width="20" height="20" src="{$IMG*,icons/trays/expand}" /></a>
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{CAPTION*}</a>
		</span>

		<ul style="display: none" class="compact-list toggleable-tray js-tray-content">
			{CONTENTS}
		</ul>
	</div>
{+END}
