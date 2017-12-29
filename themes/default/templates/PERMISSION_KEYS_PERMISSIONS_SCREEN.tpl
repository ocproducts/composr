{$REQUIRE_JAVASCRIPT,core_permission_management}

<div data-tpl="permissionKeysPermissionsScreen">
	{TITLE}

	<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			<p>
				{!PAGE_MATCH_KEY_ACCESS_TEXT}
			</p>

			<div class="wide-table-wrap"><table class="columned_table wide-table results-table privileges responsive-table">
				<colgroup>
					<col class="match_key_name_column" />
					{COLS}
					<col class="permission-copy-column" />
				</colgroup>

				<thead>
				<tr>
					<th class="permission_header_cell">{!MATCH_KEY}</th>
					{HEADER_CELLS}
				</tr>
				</thead>

				<tbody>
				{ROWS}
				</tbody>
			</table></div>

			<h2>{!MATCH_KEY_MESSAGES}</h2>

			<p>
				{!PAGE_MATCH_KEY_MESSAGES_TEXT}
			</p>

			<div class="wide-table-wrap"><table class="columned_table wide-table results-table responsive-table">
				<colgroup>
					<col class="match_key_name_column" />
					<col class="permission_match_key_message_column" />
				</colgroup>

				<thead>
				<tr>
					<th>
						{!MATCH_KEY}
					</th>
					<th>
						{!MATCH_KEY_MESSAGE_FIELD}
						<a data-open-as-overlay="{}" class="link_exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,:userguide_comcode}"><img src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" class="vertical_alignment" alt="{!COMCODE_MESSAGE,Comcode}" /></a>
					</th>
				</tr>
				</thead>

				<tbody>
				{ROWS2}
				</tbody>
			</table></div>

			<p class="proceed_button">
				<input accesskey="u" data-disable-on-click="1" class="button_screen buttons--save js-btn-hover-toggle-disable-size-change" type="submit" value="{!SAVE}" />
			</p>
		</div>
	</form>
</div>
