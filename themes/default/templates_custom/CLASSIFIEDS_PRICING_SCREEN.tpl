{TITLE}

<p>
	{!CLASSIFIEDS_SET_PRICES}
</p>

<form id="main_form" action="{POST_URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		<div class="wide_table_wrap"><table class="wide_table results_table autosized_table columned_table responsive-table">
			<thead>
				<tr>
					<th>{!CATALOGUE}</th>
					<th>{!CLASSIFIEDS_DAYS}</th>
					<th>{!TITLE}</th>
					<th>{!PRICE}</th>
				</tr>
			</thead>

			<tbody>
				{+START,LOOP,PRICES}
					<tr>
						<td>
							<label for="catalogue_{ID*}" class="accessibility_hidden">{!CATALOGUE}</label>
							<select name="catalogue_{ID*}" id="catalogue_{ID*}">
								<option value="">&mdash;</option>
								{+START,LOOP,CATALOGUES}
									<option value="{_loop_key*}"{+START,IF,{$EQ,{_loop_key},{PRICE_CATALOGUE}}} selected="selected"{+END}>{_loop_var*}</option>
								{+END}
							</select>
						</td>
						<td>
							<label for="days_{ID*}" class="accessibility_hidden">{!DAYS}</label>
							<input maxlength="5" name="days_{ID*}" id="days_{ID*}" value="{PRICE_DAYS*}" class="input_integer" type="number" data-cms-invalid-pattern="[^\-\d{$BACKSLASH}{$DECIMAL_POINT*}]" />
						</td>
						<td>
							<label for="label_{ID*}" class="accessibility_hidden">{!TITLE}</label>
							<input maxlength="255" name="label_{ID*}" id="label_{ID*}" value="{PRICE_LABEL*}" class="input_line" size="30" type="text" />
						</td>
						<td>
							<label for="price_{ID*}" class="accessibility_hidden">{!PRICE}</label>
							<input maxlength="10" name="price_{ID*}" id="price_{ID*}" value="{PRICE_PRICE*}" class="input_float" step="0.01" type="number" data-cms-invalid-pattern="[^\-\d{$BACKSLASH}{$DECIMAL_POINT*}]" />
						</td>
					</tr>
				{+END}
			</tbody>
		</table></div>

		{+START,INCLUDE,FORM_STANDARD_END}
			FORM_NAME=main_form
			SUPPORT_AUTOSAVE=1
		{+END}
	</div>
</form>
