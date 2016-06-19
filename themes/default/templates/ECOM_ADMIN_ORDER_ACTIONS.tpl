<div class="vertical_align">
	<form title="{!ACTION}: {ORDER_TITLE*}" method="post" action="{ORDER_ACTUALISE_URL*}" onsubmit="return confirm_admin_order_actions(this.elements['action'].value,this);" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<label class="accessibility_hidden" for="action">{!ACTION}</label>

		<select onchange="if (this.selectedIndex!=0) this.form.submit();/*guarded*/" name="action" id="action" class="orders_actions_dropdown">
			<option value="">{!CHOOSE}&hellip;</option>

			<option value="add_note">{!ADD_NOTE}</option>

			<option value="del_order">{!CANCEL}</option>

			{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_cancelled},{!ORDER_STATUS_awaiting_payment}}}
				{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_dispatched}}}
					<option value="dispatch">{!DISPATCH}</option>
				{+END}
				{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_returned}}}
					<option value="return">{!RETURN_PRODUCT}</option>
				{+END}
				{+START,IF,{$NEQ,{ORDER_STATUS},{!ORDER_STATUS_onhold}}}
					<option value="hold">{!HOLD_ORDER}</option>
				{+END}
			{+END}
		</select>

		{+START,IF,{$NOT,{$JS_ON}}}
			<input class="button_screen_item buttons__proceed" type="submit" name="action_button" title="{!PROCEED}: {ORDER_TITLE*}" value="{!PROCEED_SHORT}" />
		{+END}
	</form>
</div>
