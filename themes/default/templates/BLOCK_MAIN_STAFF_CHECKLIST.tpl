<section id="tray_{!CHECK_LIST|}" class="box box___block_main_staff_checklist">
	<h3 class="toggleable_tray_title">
		<a href="#" onclick="set_task_hiding(false); return false;" id="checklist_show_all_link" class="top_left_toggleicon" title="{!SHOW_ALL}: {!CHECK_LIST}">{!SHOW_ALL}</a>
		<a href="#" onclick="set_task_hiding(true); return false;" id="checklist_hide_done_link" class="top_left_toggleicon">{!HIDE_DONE}</a>

		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!CHECK_LIST|}');"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!CHECK_LIST}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!CHECK_LIST|}');">{!CHECK_LIST}</a>
	</h3>

	<div class="toggleable_tray">
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

		<form title="{!CUSTOM_TASKS}" action="{URL*}" method="post" class="add_custom_task" onsubmit="return submit_custom_task(this);" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div class="right">
				<label class="accessibility_hidden" for="recur_interval">{!TASK_LENGTH}</label>
				<label class="accessibility_hidden" for="recur_every">{!TASK_LENGTH_UNITS}</label>
				{!RECUR_EVERY,<input maxlength="8" value="" type="number" id="recur_interval" name="recur_interval" size="3" />,<select id="recur_every" name="recur_every"><option value="mins">{!dates:DPLU_MINUTES}</option><option value="hours">{!dates:DPLU_HOURS}</option><option value="days">{!dates:DPLU_DAYS}</option><option value="months">{!dates:DPLU_MONTHS}</option></select>}
				<input class="button_micro menu___generic_admin__add_one" type="submit" name="save" title="{!ADD} ({!CUSTOM_TASKS})" value="{!ADD}" />
			</div>
			<div class="constrain_field">
				<a onclick="return open_link_as_overlay(this);" class="link_exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SEARCH:userguide_comcode}"><img class="vertical_alignment" alt="" src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" /></a>
				<label class="accessibility_hidden" for="new_task">{!DESCRIPTION}</label>
				<input maxlength="255" value="" type="text" id="new_task" name="new_task" size="32" />
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

{$REQUIRE_JAVASCRIPT,staff}

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		set_task_hiding(true);
		{+START,IF,{$JS_ON}}
			handle_tray_cookie_setting('{!CHECK_LIST|}');
		{+END}
	});
//]]></script>
