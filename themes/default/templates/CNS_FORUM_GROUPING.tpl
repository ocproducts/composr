<div class="cns_forum_grouping">
	<h3 class="toggleable_tray_title_heading">
		<span class="cns_forum_grouping_toggleable_tray_button">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray('c_{GROUPING_ID;*}');"><img title="{!TOGGLE_GROUPING_VISIBILITY}" alt="{!TOGGLE_GROUPING_VISIBILITY}" src="{$IMG*,1x/trays/{EXPAND_TYPE*}2}" srcset="{$IMG*,2x/trays/{EXPAND_TYPE*}2} 2x" /></a>
		</span>
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray('c_{GROUPING_ID;*}');">{GROUPING_TITLE*}</a>
		{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_cns_forum_groupings}}<span class="associated_details">(<a href="{$PAGE_LINK*,_SEARCH:admin_cns_forum_groupings:_edit:{GROUPING_ID}}">{!EDIT}</a>)</span>{+END}

		{+START,IF_NON_EMPTY,{GROUPING_DESCRIPTION}}
			&ndash; <span class="associated_details">{GROUPING_DESCRIPTION*}</span>
		{+END}
	</h3>

	<div class="toggleable_tray" id="c_{GROUPING_ID*}"{+START,IF,{$NEQ,{DISPLAY},block}} style="{$JS_ON,display: {DISPLAY*},}"{+END}>
		<div class="wide_table_wrap">
			<table class="columned_table wide_table cns_forum_grouping" itemprop="significantLinks">
				{+START,IF,{$NOT,{$MOBILE}}}
					<colgroup>
						<col class="cns_forum_grouping_column1" />
						<col class="cns_forum_grouping_column2" />
						<col class="cns_forum_grouping_column3" />
						<col class="cns_forum_grouping_column4" />
						<col class="cns_forum_grouping_column5" />
					</colgroup>
				{+END}

				<thead>
					<tr>
						{+START,IF,{$NOT,{$MOBILE}}}
							<th class="ocf_forum_box_left"></th>
						{+END}
						<th{+START,IF,{$MOBILE}} class="cns_forum_box_left"{+END}>
							{!FORUM_NAME}
						</th>
						{+START,IF,{$NOT,{$MOBILE}}}
							<th class="cns_forum_grouping_centered_header">
								{!COUNT_TOPICS}
							</th>
							<th class="cns_forum_grouping_centered_header">
								{!COUNT_POSTS}
							</th>
						{+END}
						<th class="cns_forum_box_right">
							{!LAST_POST}
						</th>
					</tr>
				</thead>

				<tbody>
					{FORUMS}
				</tbody>
			</table>
			<div class="cns_table_footer"><div><div>
				{+START,IF,{$NOT,{$MOBILE}}}
					<div class="cns_column1 cns_forum_box_bleft"></div>
				{+END}
				<div class="cns_column1{+START,IF,{$MOBILE}} cns_forum_box_bleft{+END}"></div>
				{+START,IF,{$NOT,{$MOBILE}}}
					<div class="cns_column1"></div>
					<div class="cns_column1"></div>
				{+END}
				<div class="cns_column1 cns_forum_box_bright"></div>
			</div></div></div>
		</div>
	</div>
</div>


