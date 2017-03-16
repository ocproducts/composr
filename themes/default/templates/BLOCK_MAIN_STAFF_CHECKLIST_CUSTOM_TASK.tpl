<div class="checklist_row" onclick="{$?,{$EQ,{TASK_DONE},not_completed},mark_done,mark_undone}(this,{ID%});" onmouseover="this.getElementsByTagName('img')[0].setAttribute('src','{$IMG;*,checklist/cross2}');" onmouseout="this.getElementsByTagName('img')[0].setAttribute('src','{$IMG;*,checklist/cross}');">
	<div class="float_surrounder">
		<p class="checklist_task_status">
			<span>{!ADDED_SIMPLE,<strong>{ADD_TIME*}</strong>}{+START,IF_NON_EMPTY,{RECUR_INTERVAL}}, {!RECUR_EVERY,{RECUR_INTERVAL*},{RECUR_EVERY*}}{+END}</span>
			{+START,IF,{$JS_ON}}
				<a onclick="cancel_bubbling(event,this); var t=this; window.fauxmodal_confirm('{!CONFIRM_DELETE;^*,{$STRIP_TAGS,{TASK_TITLE}}}',function(result) { if (result) { delete_custom_task(t,'{ID%}'); } }); return false;" href="#"><img src="{$IMG*,checklist/cross}" title="{!DELETE}" alt="{!DELETE}: {$STRIP_TAGS,{TASK_TITLE}}" /></a>
			{+END}
		</p>
		<p class="checklist_task">
			<img src="{$IMG*,checklist/{TASK_DONE}}" title="{!MARK_TASK_DONE}" alt="" />
			<span>{TASK_TITLE}</span>
		</p>
	</div>
</div>
