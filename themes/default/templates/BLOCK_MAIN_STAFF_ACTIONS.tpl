{$REQUIRE_JAVASCRIPT,checking}

{$SET,ajax_block_main_staff_actions_wrapper,ajax_block_main_staff_actions_wrapper_{$RAND%}}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}}

<section id="tray_{!MODULE_TRANS_NAME_admin_actionlog|}" data-view="ToggleableTray" data-tray-cookie="{!MODULE_TRANS_NAME_admin_actionlog|}" data-tpl="blockMainStaffActions" data-tpl-params="{+START,PARAMS_JSON,ajax_block_main_staff_actions_wrapper,block_call_url}{_*}{+END}" class="box box___block_main_staff_actions">
	<h3 class="toggleable_tray_title js-tray-header">
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!MODULE_TRANS_NAME_admin_actionlog}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{!MODULE_TRANS_NAME_admin_actionlog}</a>
	</h3>

	<div class="toggleable_tray js-tray-content">
		<div id="{$GET*,ajax_block_main_staff_actions_wrapper}">
			{CONTENT}
		</div>
	</div>
</section>