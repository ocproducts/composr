{+START,IF_NON_EMPTY,{CATEGORY_NAME}}
	<div>
		<h2>
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {CATEGORY_NAME*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{CATEGORY_NAME*}</a>
		</h2>

		<div class="toggleable_tray" style="display: {$JS_ON,{DISPLAY*},block}"{+START,IF,{$EQ,{DISPLAY},none}} aria-expanded="false"{+END}>
			<div class="float_surrounder">
				{CATEGORY}
			</div>
		</div>
	</div>
{+END}

{+START,IF_EMPTY,{CATEGORY_NAME}}
	<div class="float_surrounder theme_image__{FIELD_NAME|*}">
		{CATEGORY}
	</div>
{+END}
