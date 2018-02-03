<section id="tray-{!VERSION_ABOUT|,{VERSION}}" data-toggleable-tray="{ save: true }" class="box box---block-main-staff-new-version">
	<h3 class="toggleable-tray-title js-tray-header">
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!VERSION_ABOUT,{VERSION*}}}" title="{!CONTRACT}" width="24" height="24" width="24" height="24" src="{$IMG*,icons/trays/contract2}" /></a>

		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!VERSION_ABOUT,{VERSION*}}</a>
	</h3>

	<div class="toggleable-tray js-tray-content">
		<div class="staff-new-versions">
			{VERSION_TABLE}

			{+START,IF,{HAS_UPDATED_ADDONS}}
				<p class="red-alert">
					{!addons:SOME_ADDONS_UPDATED,{$PAGE_LINK*,_SEARCH:admin_addons}}
				</p>
			{+END}

			<div class="img-wrap">
				<img width="400" height="140" src="{$IMG*,product_logo}" alt="" />
			</div>
		</div>
	</div>
</section>
