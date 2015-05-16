<div class="checklist_row"{+START,IF_PASSED,CONFIG_URL} onmouseover="this.getElementsByTagName('img')[0].setAttribute('src','{$IMG;*,checklist/toggleicon2}');" onmouseout="this.getElementsByTagName('img')[0].setAttribute('src','{$IMG;*,checklist/toggleicon}');"{+END}>
	<div class="float_surrounder">
		{+START,IF_PASSED,INFO}{+START,IF_NON_EMPTY,{INFO}}
			<p class="checklist_task_status">{INFO*}
				{+START,IF_PASSED,CONFIG_URL}
					<a href="{CONFIG_URL*}"><img title="{!CHANGE_REGULARITY}" alt="{!CHANGE_REGULARITY}: {$STRIP_TAGS,{TASK}}" src="{$IMG*,checklist/toggleicon}" /></a>
				{+END}
				{+START,IF_NON_PASSED,CONFIG_URL}
					<img alt="" src="{$IMG*,blank}" width="14" />
				{+END}
			</p>
		{+END}{+END}

		<p class="checklist_task">
			{STATUS}

			{+START,IF_NON_EMPTY,{URL}}
				<a href="{URL*}">{TASK}</a>
			{+END}
			{+START,IF_EMPTY,{URL}}
				<span>{TASK}</span>
			{+END}
		</p>
	</div>
</div>

