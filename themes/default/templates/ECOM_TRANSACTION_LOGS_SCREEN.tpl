{TITLE}

{RESULTS_TABLE}

<form title="{!PRIMARY_PAGE_FORM}" method="get" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1},product,id}

	<div>
		<p>
			<label for="type_code"><span class="field_name">{!PRODUCT}:</span> <select id="type_code" name="type_code">{PRODUCTS}</select></label>
			<label class="horiz_field_sep" for="purchase_id"><span class="field_name">{!PURCHASE_ID}:</span> <input maxlength="80" id="purchase_id" name="purchase_id" size="10" value="{PURCHASE_ID*}" type="text" /></label>
			<input onclick="disable_button_just_clicked(this);" class="button_micro buttons__filter" type="submit" value="{!FILTER}" />
		</p>
	</div>
</form>

<h2 class="force_margin">{!MORE} / {!ADVANCED}</h2>

<p class="lonely_label">
	{!ACTIONS}:
</p>
<nav>
	<ul class="actions_list">
		<li class="actions_list_strong">
			<a href="{$PAGE_LINK*,_SELF:_SELF:export_transactions}">{!EXPORT_TRANSACTIONS}</a>
		</li>
	</ul>
</nav>
