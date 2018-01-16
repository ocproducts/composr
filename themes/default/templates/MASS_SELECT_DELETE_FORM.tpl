<form data-tpl="massSelectDeleteForm" title="{!DELETE_SELECTION}" id="mass_select_form__{$GET%,support_mass_select}" style="display: none" class="mass_delete_form" action="{$PAGE_LINK*,_SEARCH:{$GET,support_mass_select}:mass_delete:redirect={$SELF_URL&}}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p class="proceed-button">
		<input class="button-screen-item menu---generic-admin--delete" type="submit" value="{!DELETE_SELECTION}" />
	</p>
</form>
