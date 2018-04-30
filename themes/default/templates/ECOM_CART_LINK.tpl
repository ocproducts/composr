{$,Embedded into catalogue views for example, not used for the shopping cart itself}

<span class="cart-link">
	<a class="buttons--cart-view button-screen{+START,IF,{$EQ,{ITEMS},0}} button-faded{+END}" href="{URL*}"><span>{+START,INCLUDE,ICON}NAME=menu/rich_content/ecommerce/shopping_cart{+END} {TITLE*}</span></a>
</span>
