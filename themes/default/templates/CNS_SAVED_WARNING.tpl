{$SET,question,{!CONFIRM_DELETE,{TITLE}}}
<div data-tpl="cnsSavedWarning" data-tpl-args="{+START,PARAMS_JSON,TITLE,EXPLANATION,MESSAGE,MESSAGE_HTML,question}{_*}{+END}">
	<h3>
		{TITLE*}
	</h3>
	<nav>
		<ul class="actions_list">
			<li>
				<form title="{!LOAD} {$STRIP_TAGS,{TITLE|}}" action="#" method="post" class="inline" id="saved_use__{TITLE|}" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<div class="inline">
						<input class="button_hyperlink" type="submit" value="{!LOAD} {$STRIP_TAGS,{TITLE|}}" />
					</div>
				</form>
			</li>
			<li id="saved_delete__{TITLE|}">{DELETE_LINK}</li>
		</ul>
	</nav>
</div>
