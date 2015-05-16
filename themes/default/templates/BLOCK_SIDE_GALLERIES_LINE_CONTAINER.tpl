{+START,IF_NON_EMPTY,{CONTENTS}}
	<div>
		<span class="side_galleries_block_exp toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {CAPTION*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{CAPTION*}</a>
		</span>

		<ul style="display: {$JS_ON,none,block}" class="compact_list toggleable_tray">
			{CONTENTS}
		</ul>
	</div>
{+END}
