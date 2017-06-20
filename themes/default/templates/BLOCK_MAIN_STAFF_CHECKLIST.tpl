{$REQUIRE_JAVASCRIPT,core_adminzone_dashboard}

<section id="tray_{!CHECK_LIST|}" class="box box___block_main_staff_checklist" data-tpl="blockMainStaffChecklist" data-view="ToggleableTray" data-tray-cookie="{!CHECK_LIST|}">
	<h3 class="toggleable_tray_title js-tray-header">
		<a href="#!" id="checklist_show_all_link" class="top_left_toggleicon js-click-disable-task-hiding" title="{!SHOW_ALL}: {!CHECK_LIST}">{!SHOW_ALL}</a>
		<a href="#!" id="checklist_hide_done_link" class="top_left_toggleicon js-click-enable-task-hiding">{!HIDE_DONE}</a>

		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!CHECK_LIST}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{!CHECK_LIST}</a>
	</h3>

	<div class="toggleable_tray js-tray-content">
		{+START,IF_NON_EMPTY,{DATES}}
			<h4 class="checklist_header">{!REGULAR_TASKS}</h4>

			{DATES}
		{+END}

		{+START,IF_NON_EMPTY,{TODO_COUNTS}}
			<h4 class="checklist_header">{!ONE_OFF_TASKS}</h4>

			{TODO_COUNTS}
		{+END}

		<h4 class="checklist_header">{!CUSTOM_TASKS}</h4>

		<div id="custom_tasks_go_here">
			{CUSTOM_TASKS}
		</div>

		<form title="{!CUSTOM_TASKS}" action="{URL*}" method="post" data-submit-pd="1" class="add_custom_task js-submit-custom-task" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div class="right">
				<label class="accessibility_hidden" for="recur_interval">{!TASK_LENGTH}</label>
				<label class="accessibility_hidden" for="recur_every">{!TASK_LENGTH_UNITS}</label>
				{!RECUR_EVERY,<input maxlength="8" type="number" id="recur_interval" name="recur_interval" size="3" />,<select id="recur_every" name="recur_every"><option value="mins">{!dates:DPLU_MINUTES}</option><option value="hours">{!dates:DPLU_HOURS}</option><option value="days">{!dates:DPLU_DAYS}</option><option value="months">{!dates:DPLU_MONTHS}</option></select>}
				<input class="button_micro menu___generic_admin__add_one" type="submit" name="save" title="{!ADD} ({!CUSTOM_TASKS})" value="{!ADD}" />
			</div>
			<div class="constrain_field">
				<a data-open-as-overlay="1" class="link_exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SEARCH:userguide_comcode}"><img class="vertical_alignment" alt="" src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" /></a>
				<label class="accessibility_hidden" for="new_task">{!DESCRIPTION}</label>
				<input maxlength="255" type="text" id="new_task" name="new_task" size="32" />
			</div>
		</form>

		{+START,IF_NON_EMPTY,{NO_TIMES}}
			<h4 class="checklist_header">{!OTHER_MAINTENANCE}</h4>

			<div class="float_surrounder checklist_other_maintenance">
				{NO_TIMES}
			</div>
		{+END}
	</div>
</section>
