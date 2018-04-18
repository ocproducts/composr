{$REQUIRE_JAVASCRIPT,checking}

{$SET,ajax_block_main_staff_actions_wrapper,ajax-block-main-staff-actions-wrapper-{$RAND%}}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}}

<section id="tray-{!MODULE_TRANS_NAME_admin_actionlog|}" data-toggleable-tray="{ save: true }" data-tpl="blockMainStaffActions" data-tpl-params="{+START,PARAMS_JSON,ajax_block_main_staff_actions_wrapper,block_call_url}{_*}{+END}" class="box box---block-main-staff-actions">
	<h3 class="toggleable-tray-title js-tray-header">
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!" title="{!CONTRACT}">
			{+START,INCLUDE,ICON}
				NAME=trays/contract
				SIZE=24
			{+END}
		</a>
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!MODULE_TRANS_NAME_admin_actionlog}</a> <span class="associated-details">(<a title="{!MODULE_TRANS_NAME_admin_actionlog}" href="{$PAGE_LINK*,adminzone:admin_actionlog}">{$LCASE,{!MORE}}</a>)</span>
	</h3>

	<div class="toggleable-tray js-tray-content">
		<div id="{$GET*,ajax_block_main_staff_actions_wrapper}">
			{CONTENT}
		</div>
	</div>
</section>
