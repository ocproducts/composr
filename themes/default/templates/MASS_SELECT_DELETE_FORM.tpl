<form data-tpl="massSelectDeleteForm" title="{!DELETE_SELECTION}" id="mass-select-form--{$GET%,support_mass_select}" style="display: none" class="mass-delete-form" action="{$PAGE_LINK*,_SEARCH:{$GET,support_mass_select}:mass_delete:redirect={$SELF_URL&}}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p class="proceed-button">
		<button class="button-screen-item admin--delete3" type="submit">{!DELETE_SELECTION}</button>
	</p>
</form>
