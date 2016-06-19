{TITLE}

<p>
	{!HIGHLIGHT_NAME_A,{COST},{REMAINING}}
</p>

<nav>
	<ul class="actions_list">
		<li class="actions_list_strong">
			<form title="{!PRIMARY_PAGE_FORM}" class="inline" method="post" action="{NEXT_URL*}" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="inline">
					<input type="hidden" name="confirm" value="1" />
					<input class="button_hyperlink" type="submit" value="{!PROCEED}" />
				</div>
			</form>
		</li>
	</ul>
</nav>
