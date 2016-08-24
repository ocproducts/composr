<section id="tray_{!MODULE_TRANS_NAME_admin_actionlog|}" class="box box___block_main_staff_actions">
	<h3 class="toggleable_tray_title">
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!MODULE_TRANS_NAME_admin_actionlog|}');"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!MODULE_TRANS_NAME_admin_actionlog}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!MODULE_TRANS_NAME_admin_actionlog|}');">{!MODULE_TRANS_NAME_admin_actionlog}</a>
	</h3>

	<div class="toggleable_tray">
		{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
		<div id="{$GET*,wrapper_id}">
			{CONTENT}

			{$REQUIRE_JAVASCRIPT,ajax}
			{$REQUIRE_JAVASCRIPT,checking}

			{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}}

			<script type="application/json" data-tpl-core-adminzone-dashboard="blockMainStaffActions">
				{+START,PARAMS_JSON,wrapper_id,block_call_url}{_/}{+END}
			</script>
		</div>
	</div>
</section>
