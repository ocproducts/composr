"use strict";

add_event_listener_abstract(window, 'load', function() {
	var address_fields = ['street_address', 'city', 'county', 'state', 'post_code', 'country'];
	for (var i = 0; i < address_fields.length; i++) {
		var billing = document.getElementById('billing_' + address_fields[i]);
		var shipping = document.getElementById('shipping_' + address_fields[i]);
		if (billing && shipping) {
			billing.onchange = function(billing, shipping) { return function() {
				if (billing.nodeName.toLowerCase() == 'select') {
					if (shipping.selectedIndex == 0) {
						shipping.selectedIndex = billing.selectedIndex;
						if (typeof $(shipping).select2!='undefined') {
							$(shipping).trigger('change');
						}
					}
				} else {
					if (shipping.value == '') {
						shipping.value = billing.value;
					}
				}
			} }(billing, shipping);
		}
	}
});

function update_cart(pro_ids)
{	
	var pro_ids_array=pro_ids.split(',');

	var tot=pro_ids_array.length;	

	for (var i=0;i<tot;i++)
	{	
		var quantity_data='quantity_'+pro_ids_array[i];

		var qval=document.getElementById(quantity_data).value;

		if (isNaN(qval))
		{
			window.fauxmodal_alert('{!shopping:CART_VALIDATION_REQUIRE_NUMBER;^}');
			return false;
		}
	}	
}

function confirm_empty(message,action_url,form)
{	
	window.fauxmodal_confirm(
		message,
		function() {
			form.action=action_url;
			form.submit();
		}
	);
	return false;
}

function checkout(form_name,checkout_url)
{	
	var form=document.getElementById(form_name);	
	form.action=checkout_url;
	form.submit();
	return true;
}

function confirm_admin_order_actions(action_event,form)
{
	if (action_event=='dispatch')
	{
		window.fauxmodal_confirm(
			'{!shopping:DISPATCH_CONFIRMATION_MESSAGE;^}',
			function(result)
			{
				if (result)
				{
					disable_button_just_clicked(form);
					form.submit();
				}
			}
		);
	}
	if (action_event=='del_order')
	{
		window.fauxmodal_confirm(
			'{!shopping:CANCEL_ORDER_CONFIRMATION_MESSAGE;^}',
			function(result)
			{
				if (result)
				{
					disable_button_just_clicked(form);
					form.submit();
				}
			}
		);
	}
	return false;
}
