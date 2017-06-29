{$REQUIRE_JAVASCRIPT,shopping}

<div class="vertical_align" data-tpl="ecomAdminOrderActions">
	<form title="{!ACTION}: {ORDER_TITLE*}" method="post" action="{ORDER_ACTUALISE_URL*}" data-submit-pd="1" class="js-submit-confirm-admin-order-actions" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<label class="accessibility_hidden" for="action">{!ACTION}</label>

		<select name="action" id="action" class="orders_actions_dropdown js-select-change-action-submit-form">
			<option value="">{!CHOOSE}&hellip;</option>

			<option value="add_note">{!ADD_NOTE}</option>

			<option value="del_order">{!CANCEL}</option>

			{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_cancelled},{!ORDER_STATUS_awaiting_payment}}}
				{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_dispatched}}}
					<option value="dispatch">{!DISPATCH}</option>
				{+END}
				{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_returned}}}
					<option value="return">{!RETURNED_PRODUCT}</option>
				{+END}
				{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_onhold}}}
					<option value="hold">{!HOLD_ORDER}</option>
				{+END}
			{+END}
		</select>
	</form>
</div>
