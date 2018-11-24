{$REQUIRE_JAVASCRIPT,shopping}

<div data-tpl="ecomShoppingItemQuantityField">
	<label for="quantity_{TYPE_CODE*}" class="accessibility-hidden">{!QUANTITY}</label>
	<input class="form-control js-keypress-unfade-cart-update-button" type="text" maxlength="10" size="3" name="quantity_{TYPE_CODE*}" id="quantity_{TYPE_CODE*}" value="{QUANTITY*}" />
</div>
