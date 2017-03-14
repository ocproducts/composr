{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" action="{UPDATE_CART_URL*}" method="post" itemscope="itemscope" itemtype="http://schema.org/CheckoutPage" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{RESULTS_TABLE}

	<div class="cart_buttons">
		<div class="buttons_group cart_update_buttons" itemprop="significantLinks">
			{$,Put first, so it associates with the enter key}
			{+START,IF_NON_EMPTY,{TYPE_CODES}}
				<input id="cart_update_button" class="buttons__cart_update button_screen_item{+START,IF,{$JS_ON}} button_faded{+END}" type="submit" name="update" onclick="return update_cart('{TYPE_CODES;*}');" title="{!UPDATE_CART}" value="{!_UPDATE_CART}" />
			{+END}

			{+START,IF_NON_EMPTY,{EMPTY_CART_URL*}}
				<input class="button_screen_item buttons__cart_empty" type="submit" onclick="return confirm_empty('{!EMPTY_CONFIRM}','{EMPTY_CART_URL;*}',this.form);" value="{!EMPTY_CART}" />
			{+END}
		</div>

		<div class="buttons_group cart_continue_button" itemprop="significantLinks">
			<input type="hidden" name="type_codes" id="type_codes" value="{TYPE_CODES*}" />

			{+START,IF_NON_EMPTY,{CONTINUE_SHOPPING_URL}}
				<a class="button_screen_item menu__rich_content__catalogues__products" href="{CONTINUE_SHOPPING_URL*}"><span>{!CONTINUE_SHOPPING}</span></a>
			{+END}
		</div>
	</div>
</form>

{+START,IF_NON_EMPTY,{TYPE_CODES}}
	<div class="cart_payment_line">
		{!SHIPPING}:
		<span class="tax">{$CURRENCY,{$ADD,{TOTAL_SHIPPING_COST},{TOTAL_SHIPPING_TAX}},{CURRENCY},{$?,{$CONFIG_OPTION,currency_auto},{$CURRENCY_USER},{$CURRENCY}}}</span>
	</div>

	<div class="cart_payment_summary">
		{!GRAND_TOTAL}:
		<span class="price">{$CURRENCY,{GRAND_TOTAL},{CURRENCY},{$?,{$CONFIG_OPTION,currency_auto},{$CURRENCY_USER},{$CURRENCY}}}</span>
	</div>
{+END}

<form title="{!PRIMARY_PAGE_FORM}" method="post" enctype="multipart/form-data" action="{NEXT_URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{+START,IF_PASSED,FIELDS}
		<div class="wide_table_wrap"><table class="map_table form_table wide_table">
			{+START,IF,{$NOT,{$MOBILE}}}
				<colgroup>
					<col class="purchase_field_name_column" />
					<col class="purchase_field_input_column" />
				</colgroup>
			{+END}

			<tbody>
				{FIELDS}
			</tbody>
		</table></div>
	{+END}

	{+START,IF_PASSED,JAVASCRIPT}
		<script>// <![CDATA[
			{JAVASCRIPT/}
		//]]></script>
	{+END}

	<p class="purchase_button">
		<input id="proceed_button" onclick="if (typeof this.form=='undefined') var form=window.form_submitting; else var form=this.form; return do_form_submit(form,event);" class="button_screen buttons__proceed" accesskey="u" type="button" value="{!CHECKOUT}" />
	</p>
</form>
