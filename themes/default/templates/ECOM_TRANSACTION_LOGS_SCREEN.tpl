{TITLE}

{RESULTS_TABLE}

<form title="{!PRIMARY_PAGE_FORM}" method="get" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1},product,id}

	<div>
		<p>
			<label for="type_code"><span class="field-name">{!PRODUCT}:</span> <select id="type_code" name="type_code">{PRODUCTS}</select></label>
			<label class="horiz-field-sep" for="purchase_id"><span class="field-name">{!PURCHASE_ID}:</span> <input maxlength="80" id="purchase_id" name="purchase_id" size="10" value="{PURCHASE_ID*}" type="text" /></label>
			<button data-disable-on-click="1" class="button-micro buttons--filter" type="submit">{!FILTER}</button>
		</p>
	</div>
</form>

<h2 class="force-margin">{!MORE} / {!ADVANCED}</h2>

<p class="lonely-label">
	{!ACTIONS}:
</p>
<nav>
	<ul class="actions-list">
		<li class="actions-list-strong">
			<a href="{$PAGE_LINK*,_SELF:_SELF:export_transactions}">{!EXPORT_TRANSACTIONS}</a>
		</li>
	</ul>
</nav>
