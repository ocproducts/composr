{$SET,rndx,{$RAND}}

<li class="float_surrounder" data-toggleable-tray="{}">
	<div class="js-tray-header">
		<label for="banned_{$GET*,rndx}">
			<kbd>{MASK*}</kbd>
			{+START,IF,{$ADDON_INSTALLED,securitylogging}}
				<span class="horiz_field_sep"><em>{!BANNED}: <input type="checkbox" id="banned_{$GET*,rndx}" name="banned[]" value="{MASK*}"{+START,IF,{BANNED}} checked="checked"{+END} /></em></span>
			{+END}
		</label>

		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{$?,{OPEN_DEFAULT},{!CONTRACT},{!EXPAND}}" title="{$?,{OPEN_DEFAULT},{!CONTRACT},{!EXPAND}}" src="{$IMG*,1x/trays/{$?,{OPEN_DEFAULT},contract,expand}}" srcset="{$IMG*,2x/trays/{$?,{OPEN_DEFAULT},contract,expand}} 2x" /></a>
	</div>

	<div class="toggleable_tray js-tray-content" style="display: {$?,{OPEN_DEFAULT},block,none}"{+START,IF,{$NOT,{OPEN_DEFAULT}}} aria-expanded="false"{+END}>
		<ul>
			{GROUP}
		</ul>
	</div>
</li>
