<div data-tpl="installerStep4SectionHide" data-tpl-params="{+START,PARAMS_JSON,TITLE}{_*}{+END}">
	<p class="lonely_label">
		<a class="toggleable_tray_button js-click-toggle-title-section" href="#!">{!ADVANCED_BELOW}:</a>
		<a class="toggleable_tray_button js-click-toggle-title-section" href="#!">
			<img id="img_{TITLE|*}" alt="{!EXPAND}: {$STRIP_TAGS,{TITLE}}" title="{!EXPAND}" src="{$BASE_URL*}/install.php?type=expand" />
		</a>
	</p>
	
	<div id="{TITLE|*}" style="display: none">
		{CONTENT}
	</div>
</div>