{TITLE}

<p>
	{!DECIDE_PER_CATEGORY_NOTIFICATIONS,{_TITLE*}}
</p>

<form title="{!NOTIFICATIONS}" method="post" action="{ACTION_URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		{+START,IF_NON_EMPTY,{$TRIM,{TREE}}}
			<div class="wide_table"><table class="columned_table wide_table results_table notifications_form">
				<colgroup>
					<col class="notifications_field_name_column" />
					{+START,LOOP,NOTIFICATION_TYPES_TITLES}
						<col class="notifications_tick_column" />
					{+END}
				</colgroup>

				<thead>
					<tr>
						<th></th>
						{+START,LOOP,NOTIFICATION_TYPES_TITLES}
							<th>
								<img class="gd_text" src="{$BASE_URL*}/data/gd_text.php?trans_color={COLOR*}&amp;text={$ESCAPE,{LABEL},UL_ESCAPED}{$KEEP*}" title="" alt="{LABEL*}" />
							</th>
						{+END}
					</tr>
				</thead>

				<tbody>
					{TREE}
				</tbody>
			</table></div>

			<p class="proceed_button">
				<input type="submit" class="button_screen buttons__save" value="{!SAVE}" />
			</p>
		{+END}

		{+START,IF_EMPTY,{$TRIM,{TREE}}}
			<p class="nothing_here">
				{!NO_CATEGORIES}
			</p>
		{+END}
	</div>
</form>
