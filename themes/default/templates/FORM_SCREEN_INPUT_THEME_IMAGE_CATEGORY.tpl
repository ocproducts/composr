{+START,IF_NON_EMPTY,{CATEGORY_NAME}}
	<div data-toggleable-tray="{}">
		<h3 class="js-tray-header">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {CATEGORY_NAME*}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" /></a>
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{CATEGORY_NAME*}</a>
		</h3>

		<div class="toggleable_tray js-tray-content" style="display: {DISPLAY*}"{+START,IF,{$EQ,{DISPLAY},none}} aria-expanded="false"{+END}>
			<div class="float-surrounder">
				{CATEGORY}
			</div>
		</div>
	</div>
{+END}

{+START,IF_EMPTY,{CATEGORY_NAME}}
	<div class="float-surrounder theme_image__{FIELD_NAME|*}">
		{CATEGORY}
	</div>
{+END}
