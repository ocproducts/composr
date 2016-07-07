{TITLE}

{RESULTS_TABLE}

<form title="{!PRIMARY_PAGE_FORM}" method="get" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1},product,id}

	<div>
		<p>
			<label for="type_code"><span class="field_name">{!PRODUCT}:</span> <select id="type_code" name="type_code">{PRODUCTS}</select></label>
			<label class="horiz_field_sep" for="id"><span class="field_name">{!IDENTIFIER}:</span> <input maxlength="80" id="id" name="id" size="10" value="" type="text" /></label>
			<input onclick="disable_button_just_clicked(this);" class="button_micro buttons__filter" type="submit" value="{!FILTER}" />
		</p>
	</div>
</form>

