{$SET,purchase_url,{$PAGE_LINK,_SEARCH:purchase:terms:member_id={$MEMBER}}}
<form class="quoteCst" action="{$URL_FOR_GET_FORM*,{$GET,purchase_url}}" method="get" style="margin-bottom: 0">
	{$HIDDENS_FOR_GET_FORM,{$GET,purchase_url}}

	<div class="selCdt">
		<label for="type_code">{LABEL_BUY}</label>
		<select name="type_code" id="type_code" onchange="update_product_info_display();">
			{+START,LOOP,CREDIT_KINDS}
				<option{+START,IF,{$EQ,{NUM_CREDITS},50}} selected="selected"{+END} value="{NUM_CREDITS*}_CREDITS">{$NUMBER_FORMAT*,{NUM_CREDITS}} credits</option>
			{+END}
		</select>
	</div>

	{+START,LOOP,CREDIT_KINDS}
		<div class="creditsInfo" id="info_{NUM_CREDITS*}_CREDITS">
			<p>{!BLOCK_CREDITS_EXP_INNER_MSG,{$NUMBER_FORMAT*,{NUM_CREDITS}},{$COMCODE,[currency="{S_CURRENCY}" bracket="1"]{PRICE}[/currency]}}</p>

			<table class="columned_table topTble">
				<thead>
					<tr>
						<th>
							{!PRIORITY_LEVEL}
						</th>
						<th>
							{!NUMBER_OF_MINUTES}
						</th>
					</tr>
				</thead>

				<tbody>
					<tr>
						<td>
							{!SUPPORT_PRIORITY_backburner}
						</td>
						<td>
							{!SUPPORT_minutes,<strong>{$NUMBER_FORMAT*,{$MULT,{NUM_CREDITS},{BACKBURNER_MINUTES}}}</strong>}
						</td>
					</tr>

					<tr>
						<td>
							{!SUPPORT_PRIORITY_regular}
						</td>
						<td>
							{!SUPPORT_minutes,<strong>{$NUMBER_FORMAT*,{$MULT,{NUM_CREDITS},{REGULAR_MINUTES}}}</strong>}
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	{+END}

	<script>// <![CDATA[
		function update_product_info_display()
		{
			var type_code=document.getElementById('type_code');
			var value=type_code.options[type_code.selectedIndex].value;
			var creditsInfo=get_elements_by_class_name(document.body,'creditsInfo');
			for (var i=0;i<creditsInfo.length;i++)
			{
				creditsInfo[i].style.display=(creditsInfo[i].id=='info_'+value)?'block':'none';
			}
		}
		update_product_info_display();
	//]]></script>

	<div class="purchaseBtn">
		<input type="submit" value="Purchase" />
	</div>
</form>
