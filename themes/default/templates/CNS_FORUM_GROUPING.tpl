<div class="cns-forum-grouping" data-toggleable-tray="{}">
	<h3 class="toggleable-tray-title-heading js-tray-header">
		<span class="cns-forum-grouping-toggleable-tray-button">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img title="{!TOGGLE_GROUPING_VISIBILITY}" alt="{!TOGGLE_GROUPING_VISIBILITY}" src="{$IMG*,1x/trays/{EXPAND_TYPE*}2}" /></a>
		</span>
		<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{GROUPING_TITLE*}</a>
		{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_cns_forum_groupings}}<span class="associated-details">(<a href="{$PAGE_LINK*,_SEARCH:admin_cns_forum_groupings:_edit:{GROUPING_ID}}">{!EDIT}</a>)</span>{+END}

		{+START,IF_NON_EMPTY,{GROUPING_DESCRIPTION}}
			&ndash; <span class="associated-details">{GROUPING_DESCRIPTION*}</span>
		{+END}
	</h3>

	<div class="toggleable-tray js-tray-content" id="c_{GROUPING_ID*}"{+START,IF,{$NEQ,{DISPLAY},block}} style="display: {DISPLAY*}"{+END}>
		<div class="wide-table-wrap">
			<table class="columned-table wide-table cns-forum-grouping" itemprop="significantLinks">
				{+START,IF,{$DESKTOP}}
					<colgroup>
						<col class="cns-forum-grouping-column1 column-desktop" />
						<col class="cns-forum-grouping-column2" />
						<col class="cns-forum-grouping-column3 column-desktop" />
						<col class="cns-forum-grouping-column4 column-desktop" />
						<col class="cns-forum-grouping-column5" />
					</colgroup>
				{+END}

				<thead>
					<tr>
						{+START,IF,{$DESKTOP}}
							<th class="ocf_forum_box_left cell-desktop"></th>
						{+END}
						<th {+START,IF,{$MOBILE}} class="cns-forum-box-left"{+END}>
							{!FORUM_NAME}
						</th>
						{+START,IF,{$DESKTOP}}
							<th class="cns-forum-grouping-centered-header cell-desktop">
								{!COUNT_TOPICS}
							</th>
							<th class="cns-forum-grouping-centered-header cell-desktop">
								{!COUNT_POSTS}
							</th>
						{+END}
						<th class="cns-forum-box-right">
							{!LAST_POST}
						</th>
					</tr>
				</thead>

				<tbody>
					{FORUMS}
				</tbody>
			</table>
			<div class="cns-table-footer"><div><div>
				{+START,IF,{$DESKTOP}}
					<div class="cns-column1 cns-forum-box-bleft"></div>
				{+END}
				<div class="cns-column1{+START,IF,{$MOBILE}} cns-forum-box-bleft{+END}"></div>
				{+START,IF,{$DESKTOP}}
					<div class="cns-column1 block-desktop"></div>
					<div class="cns-column1 block-desktop"></div>
				{+END}
				<div class="cns-column1 cns-forum-box-bright"></div>
			</div></div></div>
		</div>
	</div>
</div>
