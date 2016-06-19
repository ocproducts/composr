{TITLE}

<div class="wide_table_wrap">
	{RESULTS_TABLE}

	{+START,IF_NON_EMPTY,{PAGINATION}}
		<div class="pagination_spacing float_surrounder">
			{PAGINATION}
		</div>
	{+END}
</div>

<h2 class="force_margin">{!SEARCH}</h2>

<form title="{!SEARCH}" target="_self" method="get" action="{SEARCH_URL*}" onsubmit="try { window.scrollTo(0,0); } catch(e) {}" autocomplete="off">
	<div>
		{HIDDEN}

		<label for="order_filter">
			<span class="invisible_ref_point"></span>
			<input maxlength="255" type="text" id="order_filter" name="search" value="{SEARCH_VAL*}" /><input onclick="disable_button_just_clicked(this);" class="button_micro buttons__search" type="submit" value="{!SEARCH}" /> ({!SEARCH_ORDERS})
		</label>
	</div>
</form>

<h2 class="force_margin">{!MORE} / {!ADVANCED}</h2>

<p class="lonely_label">
	{!ACTIONS}:
</p>
<nav>
	<ul class="actions_list">
		<li class="actions_list_strong">
			<a href="{$PAGE_LINK*,_SELF:_SELF:order_export}">{!EXPORT_ORDER_LIST}</a>
		</li>
	</ul>
</nav>
