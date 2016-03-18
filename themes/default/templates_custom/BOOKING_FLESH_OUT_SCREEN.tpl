{TITLE}

{+START,SET,fleshed}
	{+START,LOOP,BOOKABLES}
		{+START,IF,{$OR,{BOOKABLE_SUPPORTS_NOTES},{$IS_NON_EMPTY,{BOOKABLE_SUPPLEMENTS}}}}
			<h2>{BOOKABLE_TITLE*}</h2>

			{+START,IF,{BOOKABLE_SUPPORTS_NOTES}}
				{+START,INCLUDE,BOOKABLE_NOTES}{+END}
			{+END}

			{+START,LOOP,BOOKABLE_SUPPLEMENTS}
				<div style="padding-left: 50px">
					<p>
						<label for="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_quantity">
							<h3>{SUPPLEMENT_TITLE*} ({!OPTIONAL_SUPPLEMENT})</h3>

							{+START,IF,{SUPPLEMENT_SUPPORTS_QUANTITY}}
								{!QUANTITY}

								<select onchange="recalculate_price(this.form);" id="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_quantity" name="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_quantity">
									{$SET,quantity,0}
									{+START,WHILE,{$LT,{$GET,quantity},51}}
										<option{+START,IF,{$EQ,{SUPPLEMENT_QUANTITY},{$GET,quantity}}} selected="selected"{+END} value="{$GET*,quantity}">{$NUMBER_FORMAT*,{$GET,quantity}}</option>
										{$INC,quantity}
									{+END}
								</select>
							{+END}

							{+START,IF,{$NOT,{SUPPLEMENT_SUPPORTS_QUANTITY}}}
								{!I_WANT_THIS}

								<input{+START,IF,{$GT,{SUPPLEMENT_QUANTITY},0}} checked="checked"{+END} onchange="recalculate_price(this.form);" type="checkbox" id="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_quantity" name="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_quantity" value="1" />
							{+END}
						</label>
					</p>

					{+START,IF,{SUPPLEMENT_SUPPORTS_NOTES}}
						<p class="lonely_label"><label for="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_notes">{!NOTES_FOR_US}:</label></p>
						<textarea cols="50" rows="1" id="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_notes" name="bookable_{BOOKABLE_ID*}_supplement_{SUPPLEMENT_ID*}_notes">{SUPPLEMENT_NOTES*}</textarea>
					{+END}
				</div>
			{+END}
		{+END}
	{+END}
{+END}

{+START,IF_NON_EMPTY,{$TRIM,{$GET,fleshed}}}
	<p>{!BOOKING_FLESH_OUT}</p>
{+END}
{+START,IF_EMPTY,{$TRIM,{$GET,fleshed}}}
	<p>{!_BOOKING_FLESH_OUT}</p>
{+END}

<form action="{POST_URL*}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		{HIDDEN}

		{$GET,fleshed}
	</div>

	{+START,IF_NON_EMPTY,{$TRIM,{$GET,fleshed}}}
		<hr class="spaced_rule" />
	{+END}

	{+START,IF,{$JS_ON}}
		<div class="box box___booking_flesh_out_screen"><div class="box_inner">
			<strong>{!PRICE_AUTO_CALC}:</strong> {$CURRENCY_SYMBOL} <span id="price">{PRICE*}</span>
		</div></div>
	{+END}

	<p class="proceed_button">
		<input class="button_screen buttons__proceed" type="submit" value="{$?,{$IS_GUEST},{!PROCEED},{!BOOK}}" />
	</p>
</form>

{+START,IF,{$JS_ON}}
	<form action="{BACK_URL*}" method="post">
		<div>
			{HIDDEN}
			<input type="image" title="{!NEXT_ITEM_BACK}" alt="{!NEXT_ITEM_BACK}" src="{$IMG*,icons/48x48/menu/_generic_admin/back}" / /></p>
		</div>
	</form>
{+END}
