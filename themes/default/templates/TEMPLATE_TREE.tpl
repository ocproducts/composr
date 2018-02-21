<form title="{!PRIMARY_PAGE_FORM} {!LINK_NEW_WINDOW}" action="{$URL_FOR_GET_FORM*,{EDIT_URL}}" method="get" target="_blank" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{EDIT_URL}}

	<div>
		{TREE`}

		{HIDDEN}
	</div>

	<p class="proceed-button">
		<input data-disable-on-click="1" value="{!EDIT_TEMPLATES}" class="button-screen admin--edit" type="submit" />
	</p>
</form>
