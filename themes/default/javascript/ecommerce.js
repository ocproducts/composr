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

