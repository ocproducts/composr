{$SET,confirm_delete_message,{!CONFIRM_DELETE,{$STRIP_TAGS,{TASK_TITLE}}}}
<div data-view="BlockMainStaffChecklistCustomTask" data-view-params="{+START,PARAMS_JSON,ID,confirm_delete_message}{_*}{+END}" data-vw-task-done="{TASK_DONE*}" class="checklist_row js-click-mark-task js-keypress-mark-task">
	<div class="float_surrounder">
		<p class="checklist_task_status">
			<span>{!ADDED_SIMPLE,<strong>{ADD_TIME*}</strong>}{+START,IF_NON_EMPTY,{RECUR_INTERVAL}}, {!RECUR_EVERY,{RECUR_INTERVAL*},{RECUR_EVERY*}}{+END}</span>

			<a class="js-click-confirm-delete" href="#!"><img src="{$IMG*,checklist/cross}" title="{!DELETE}" alt="{!DELETE}: {$STRIP_TAGS,{TASK_TITLE}}" class="js-img-checklist-cross" /></a>
		</p>
		<p class="checklist_task">
			<img src="{$IMG*,checklist/{TASK_DONE}}" title="{!MARK_TASK_DONE}" alt="" class="js-img-checklist-status" />
			<span>{TASK_TITLE}</span>
		</p>
	</div>
</div>
