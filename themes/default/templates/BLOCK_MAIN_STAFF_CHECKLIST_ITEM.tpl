{$REQUIRE_JAVASCRIPT,core_adminzone_dashboard}

<div data-tpl="blockMainStaffChecklistItem" class="checklist-row {+START,IF_PASSED,CONFIG_URL}js-hover-change-img-toggle-icon{+END}">
	<div class="float-surrounder">
		{+START,IF_PASSED,INFO}{+START,IF_NON_EMPTY,{INFO}}
			<p class="checklist-task-status">{INFO*}
				{+START,IF_PASSED,CONFIG_URL}
					<a href="{CONFIG_URL*}"><img title="{!CHANGE_REGULARITY}" alt="{!CHANGE_REGULARITY}: {$STRIP_TAGS,{TASK}}" class="js-img-toggle-icon" src="{$IMG*,checklist/toggleicon}" /></a>
				{+END}
				{+START,IF_NON_PASSED,CONFIG_URL}
					<img alt="" src="{$IMG*,blank}" width="14" />
				{+END}
			</p>
		{+END}{+END}

		<p class="checklist-task">
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
