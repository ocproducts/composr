<div class="global-helper-panel-wrap" data-view="GlobalHelperPanel">
	<a id="helper-panel-toggle" href="#!" class="js-click-toggle-helper-panel">{+START,IF,{$NOT,{$HIDE_HELP_PANEL}}}<img title="{!HELP_OR_ADVICE}: {!HIDE}" alt="{!HELP_OR_ADVICE}: {!HIDE}" width="14" height="14" src="{$IMG*,icons/28x28/helper_panel_hide}" />{+END}{+START,IF,{$HIDE_HELP_PANEL}}<img title="{!HELP_OR_ADVICE}: {!SHOW}" alt="{!HELP_OR_ADVICE}: {!SHOW}" width="14" height="14" src="{$IMG*,icons/28x28/helper_panel_show}" />{+END}</a>

	<div class="block-mobile">
		<h2>{!HELP_OR_ADVICE}</h2>
	</div>

	<div id="helper-panel-contents"{+START,IF,{$HIDE_HELP_PANEL}} style="display: none" aria-expanded="false"{+END} class="js-helper-panel-contents">
		{+START,IF,{$DESKTOP}}
			<div class="block-desktop">
				<h2>{!HELP_OR_ADVICE}</h2>
			</div>
		{+END}

		<div class="global-helper-panel">
			{+START,IF_NON_EMPTY,{$HELPER_PANEL_TEXT}}
				<div id="help" class="global-helper-panel-text">{$HELPER_PANEL_TEXT}</div>
			{+END}

			{+START,IF_NON_EMPTY,{$GET,HELPER_PANEL_TUTORIAL}}
				<div id="help_tutorial">
					<div class="box box---global-helper-panel--tutorial"><div class="box-inner">
						<div class="global-helper-panel-text">{!TUTORIAL_ON_THIS,{$TUTORIAL_URL*,{$GET,HELPER_PANEL_TUTORIAL}}}</div>
					</div></div>
				</div>
			{+END}

			{+START,IF_EMPTY,{$HELPER_PANEL_TEXT}{$GET,HELPER_PANEL_TUTORIAL}}
				<div id="help">
					<div class="box box---global-helper-panel--none"><div class="box-inner">
						<p>{!NO_HELP_HERE}</p>
					</div></div>
				</div>
			{+END}
		</div>
	</div>
</div>
