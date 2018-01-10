{TITLE}

<div class="float-surrounder">
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
	<div class="wide-table-wrap"><table class="columned-table wide-table buildr_inventory results-table buildr_centered_contents autosized-table responsive-table">
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
	<p class="nothing-here">{!W_EMPTY_INVENTORY}</p>
{+END}
