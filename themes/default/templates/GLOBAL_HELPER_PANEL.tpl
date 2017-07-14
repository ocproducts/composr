<div class="global_helper_panel_wrap" data-view="GlobalHelperPanel">
	<a id="helper_panel_toggle" href="#!" class="js-click-toggle-helper-panel">{+START,IF,{$NOT,{$HIDE_HELP_PANEL}}}<img title="{!HELP_OR_ADVICE}: {!HIDE}" alt="{!HELP_OR_ADVICE}: {!HIDE}" src="{$IMG*,icons/14x14/helper_panel_hide}" srcset="{$IMG*,icons/28x28/helper_panel_hide} 2x" />{+END}{+START,IF,{$HIDE_HELP_PANEL}}<img title="{!HELP_OR_ADVICE}: {!SHOW}" alt="{!HELP_OR_ADVICE}: {!SHOW}" src="{$IMG*,icons/14x14/helper_panel_show}" srcset="{$IMG*,icons/28x28/helper_panel_show} 2x" />{+END}</a>

	<div class="block_mobile">
		<h2>{!HELP_OR_ADVICE}</h2>
	</div>

	<div id="helper_panel_contents"{+START,IF,{$HIDE_HELP_PANEL}} style="display: none" aria-expanded="false"{+END} class="js-helper-panel-contents">
		{+START,IF,{$DESKTOP}}
			<div class="block_desktop">
				<h2>{!HELP_OR_ADVICE}</h2>
			</div>
		{+END}

		<div class="global_helper_panel">
			{+START,IF_NON_EMPTY,{$HELPER_PANEL_TEXT}}
				<div id="help" class="global_helper_panel_text">{$HELPER_PANEL_TEXT}</div>
			{+END}

			{+START,IF_NON_EMPTY,{$GET,HELPER_PANEL_TUTORIAL}}
				<div id="help_tutorial">
					<div class="box box___global_helper_panel__tutorial"><div class="box_inner">
						<div class="global_helper_panel_text">{!TUTORIAL_ON_THIS,{$TUTORIAL_URL*,{$GET,HELPER_PANEL_TUTORIAL}}}</div>
					</div></div>
				</div>
			{+END}

			{+START,IF_EMPTY,{$HELPER_PANEL_TEXT}{$GET,HELPER_PANEL_TUTORIAL}}
				<div id="help">
					<div class="box box___global_helper_panel__none"><div class="box_inner">
						<p>{!NO_HELP_HERE}</p>
					</div></div>
				</div>
			{+END}
		</div>
	</div>
</div>
