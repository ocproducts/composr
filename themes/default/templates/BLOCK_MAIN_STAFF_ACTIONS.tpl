{$REQUIRE_JAVASCRIPT,checking}

{$SET,ajax_block_main_staff_actions_wrapper,ajax_block_main_staff_actions_wrapper_{$RAND%}}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}}

<section id="tray_{!MODULE_TRANS_NAME_admin_actionlog|}" data-toggleable-tray="{ save: true }" data-tpl="blockMainStaffActions" data-tpl-params="{+START,PARAMS_JSON,ajax_block_main_staff_actions_wrapper,block_call_url}{_*}{+END}" class="box box---block-main-staff-actions">
	<h3 class="toggleable-tray-title js-tray-header">
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!MODULE_TRANS_NAME_admin_actionlog}}" title="{!CONTRACT}" width="24" height="24" src="{$IMG*,1x/trays/contract2}" /></a>
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!MODULE_TRANS_NAME_admin_actionlog}</a>
	</h3>

	<div class="toggleable-tray js-tray-content">
		<div id="{$GET*,ajax_block_main_staff_actions_wrapper}">
			{CONTENT}
		</div>
	</div>
</section>
