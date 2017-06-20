{TITLE}

<div class="float_surrounder">
	{+START,IF_NON_EMPTY,{AVATAR}}
		<div class="buildr_avatar">
			<img alt="{!AVATAR}" src="{AVATAR*}" />
			{+START,IF_NON_EMPTY,{PHOTO}}
				[<a title="{!W_PHOTO} {!LINK_NEW_WINDOW}" target="_blank" href="{PHOTO*}">{!W_PHOTO}</a>]
			{+END}
		</div>
	{+END}

	<p>
		{!W_HAS_HEALTH,{USERNAME*},{HEALTH*}}
	</p>
</div>

{+START,IF_NON_EMPTY,{INVENTORY}}
	<div class="wide_table_wrap"><table class="columned_table wide_table buildr_inventory results_table buildr_centered_contents autosized_table">
		<thead>
			<tr>
				<th>{!W_PICTURE}</th>
				<th>{!NAME}/{!DESCRIPTION}</th>
				<th>{!COUNT_TOTAL}</th>
				<th>{!W_PROPERTIES}</th>
			</tr>
		</thead>

		<tbody>
			{INVENTORY}
		</tbody>
	</table></div>
{+END}

{+START,IF_EMPTY,{INVENTORY}}
	<p class="nothing_here">{!W_EMPTY_INVENTORY}</p>
{+END}
