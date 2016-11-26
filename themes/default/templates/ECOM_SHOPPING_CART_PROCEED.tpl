{$,Embedded in the ECOM_SHOPPING_CART_SCREEN template}

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

{+START,IF_NON_EMPTY,{PAYMENT_FORM}}
	{$,Either a form or a button}
	{PAYMENT_FORM}
{+END}
