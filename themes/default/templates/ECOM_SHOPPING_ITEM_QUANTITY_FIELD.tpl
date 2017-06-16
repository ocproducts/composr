{$REQUIRE_JAVASCRIPT,shopping}

<div data-tpl="ecomShoppingItemQuantityField">
	<label for="quantity_{PRODUCT_ID*}" class="accessibility_hidden">{!QUANTITY}</label>
	<input class="js-keypress-unfade-cart-update-button" type="text" maxlength="10" size="3" name="quantity_{PRODUCT_ID*}" id="quantity_{PRODUCT_ID*}" value="{QUANTITY*}" />
</div>
