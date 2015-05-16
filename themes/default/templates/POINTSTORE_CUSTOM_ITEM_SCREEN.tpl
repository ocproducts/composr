{TITLE}

<p>
	{!CUSTOM_ITEM_A,{COST},{REMAINING}}
</p>

{+START,IF,{ONE_PER_MEMBER}}
	<p class="associated_details">
		({!POINTSTORE_ONE_PER_MEMBER})
	</p>
{+END}

<ul role="navigation" class="actions_list">
	<li class="actions_list_strong">
		<form title="{!PRIMARY_PAGE_FORM}" class="inline" method="post" action="{NEXT_URL*}">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div class="inline">
				<input type="hidden" name="confirm" value="1" />
				<input class="button_hyperlink" type="submit" value="{!PROCEED}" />
			</div>
		</form>
	</li>
</ul>
