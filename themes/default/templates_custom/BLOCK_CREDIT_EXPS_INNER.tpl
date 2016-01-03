<div class="SelCdt">
	<label for="product">{LABEL_BUY}</label>
	<select name="product" id="product" onchange="update_product_info_display();">
		{+START,LOOP,CREDIT_KINDS}
			<option{+START,IF,{$EQ,{NUM_CREDITS},50}} selected="selected"{+END} value="{NUM_CREDITS*}_CREDITS">{$NUMBER_FORMAT*,{NUM_CREDITS}} credits</option>
		{+END}
	</select>
</div>

{+START,LOOP,CREDIT_KINDS}
	<div class="creditsinfo" id="info_{NUM_CREDITS*}_CREDITS">
		<p>{!BLOCK_CREDITS_EXP_INNER_MSG,{$NUMBER_FORMAT*,{NUM_CREDITS}},{$COMCODE,[currency="{S_CURRENCY}" bracket="1"]{PRICE}[/currency]}}</p>

		<table class="columned_table topTble">
			<thead>
				<tr>
					<th>
						{TH_PRIORITY}
					</th>
					<th>
						{TH_MINUTES}
					</th>
				</tr>
			</thead>

			<tbody>
				<tr>
					<td>
						{L_B}
					</td>
					<td>
						<strong>{$NUMBER_FORMAT*,{$MULT,{NUM_CREDITS},{B_MINUTES}}}</strong> {MINUTES}
					</td>
				</tr>

				<tr>
					<td>
						{L_R}
					</td>
					<td>
						<strong>{$NUMBER_FORMAT*,{$MULT,{NUM_CREDITS},{R_MINUTES}}}</strong> {MINUTES}
					</td>
				</tr>
			</tbody>
		</table>
	</div>
{+END}

<script>// <![CDATA[
	function update_product_info_display()
	{
		var product=document.getElementById('product');
		var value=product.options[product.selectedIndex].value;
		var creditsinfo=get_elements_by_class_name(document.body,'creditsinfo');
		for (var i=0;i<creditsinfo.length;i++)
		{
			creditsinfo[i].style.display=(creditsinfo[i].id=='info_'+value)?'block':'none';
		}
	}
	update_product_info_display();
//]]></script>
