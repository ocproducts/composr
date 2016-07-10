{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" action="{FORM_URL*}" method="post" itemscope="itemscope" itemtype="http://schema.org/CheckoutPage" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{RESULTS_TABLE}

	{+START,IF_NON_EMPTY,{PRO_IDS}}
		{+START,IF,{ALLOW_OPTOUT_TAX}}
			<div class="checkout_text">
				<input type="checkbox" name="tax_opted_out" id="tax_opted_out" value="1"{+START,IF,{ALLOW_OPTOUT_TAX_VALUE}} checked="true"{+END} />
				<label for="tax_opted_out">{!CUSTOMER_OPTING_OUT_OF_TAX}</label>
			</div>
		{+END}
	{+END}

	<div class="cart_buttons">
		<div class="buttons_group cart_update_buttons" itemprop="significantLinks">
			{$,Put first, so it associates with the enter key}
			{+START,IF_NON_EMPTY,{PRO_IDS}}
				<input id="cart_update_button" class="buttons__cart_update button_screen{+START,IF,{$JS_ON}} button_faded{+END}" type="submit" name="update" onclick="return update_cart('{PRO_IDS;*}');" title="{!UPDATE_CART}" value="{!_UPDATE_CART}" />
			{+END}

			{+START,IF_NON_EMPTY,{EMPTY_CART_URL*}}
				<input class="button_screen buttons__cart_empty" type="submit" onclick="return confirm_empty('{!EMPTY_CONFIRM}','{EMPTY_CART_URL;*}',this.form);" value="{!EMPTY_CART}" />
			{+END}
		</div>

		<div class="buttons_group cart_continue_button" itemprop="significantLinks">
			<input type="hidden" name="product_ids" id="product_ids" value="{PRO_IDS*}" />

			{+START,IF_NON_EMPTY,{CONT_SHOPPING_URL}}
				<a class="button_screen menu__rich_content__catalogues__products" href="{CONT_SHOPPING_URL*}"><span>{!CONTINUE_SHOPPING}</span></a>
			{+END}
		</div>
	</div>
</form>

{PROCEED_BOX}
