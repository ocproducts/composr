{$REQUIRE_JAVASCRIPT,shopping}

<div data-tpl="ecomShoppingCartScreen" data-tpl-params="{+START,PARAMS_JSON,PRODUCT_IDS,EMPTY_CART_URL}{_*}{+END}">
    {TITLE}

    <form title="{!PRIMARY_PAGE_FORM}" action="{UPDATE_CART_URL*}" method="post" itemscope="itemscope" itemtype="http://schema.org/CheckoutPage" autocomplete="off">
        {$INSERT_SPAMMER_BLACKHOLE}

        {RESULTS_TABLE}

        {+START,IF_NON_EMPTY,{PRODUCT_IDS}}
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
                {+START,IF_NON_EMPTY,{PRODUCT_IDS}}
                <input id="cart_update_button" class="buttons__cart_update button_screen button_faded js-click-btn-cart-update" type="submit" name="update" title="{!UPDATE_CART}" value="{!_UPDATE_CART}" />
                {+END}

                {+START,IF_NON_EMPTY,{EMPTY_CART_URL*}}
                <input class="button_screen buttons__cart_empty js-click-btn-cart-empty" type="submit" value="{!EMPTY_CART}" />
                {+END}
            </div>

            <div class="buttons_group cart_continue_button" itemprop="significantLinks">
                <input type="hidden" name="product_ids" id="product_ids" value="{PRODUCT_IDS*}" />

                {+START,IF_NON_EMPTY,{CONTINUE_SHOPPING_URL}}
                <a class="button_screen menu__rich_content__catalogues__products" href="{CONTINUE_SHOPPING_URL*}"><span>{!CONTINUE_SHOPPING}</span></a>
                {+END}
            </div>
        </div>
    </form>

    {+START,IF_NON_EMPTY,{PRODUCT_IDS}}
    <table class="columned_table cart_payment_summary">
        <tbody>
        <tr>
            <th class="de_th">
                {!GRAND_TOTAL}
            </th>
            <td>
                <span class="price">{$CURRENCY_SYMBOL}{GRAND_TOTAL*}</span>
            </td>
        </tr>
        </tbody>
    </table>
    {+END}

    {+START,IF_NON_EMPTY,{PAYMENT_FORM}}
    {$,Either a form or a button}

    {+START,IF_NON_EMPTY,{FINISH_URL}}
    {$,Form}

    <h2>{!PAYMENT_HEADING}</h2>

    <form title="{!PRIMARY_PAGE_FORM}" method="post" enctype="multipart/form-data" action="{FINISH_URL*}" autocomplete="off">
        {$INSERT_SPAMMER_BLACKHOLE}

        {PAYMENT_FORM}

        <p class="purchase_button">
            <input id="proceed_button" class="button_screen buttons__proceed js-click-do-cart-form-submit" accesskey="u" type="button" value="{!MAKE_PAYMENT}" />
        </p>
    </form>
    {+END}

    {+START,IF_EMPTY,{FINISH_URL}}
    {$,Button}
    {PAYMENT_FORM}
    {+END}
    {+END}
</div>