{+START,IF_NON_EMPTY,{CONTENTS}}
	<div data-view="ToggleableTray">
		<span class="side_galleries_block_exp toggleable_tray_title js-tray-header">
			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!EXPAND}: {CAPTION*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{CAPTION*}</a>
		</span>

		<ul style="display: none" class="compact_list toggleable_tray js-tray-content">
			{CONTENTS}
		</ul>
	</div>
{+END}
