{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		<div class="wide_table_wrap"><table class="map_table wide_table results_table privileges">
			<colgroup>
				<col class="permission_field_name_column" />
				{COLS}
				<col class="permission_copy_column" />
			</colgroup>

			<thead>
				<tr>
					<th></th>
					{HEADER_CELLS}
				</tr>
			</thead>

			<tbody>
				{ROWS}
			</tbody>
		</table></div>

		<input type="hidden" name="zone" value="{ZONE*}" />

		<p class="proceed_button">
			<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__save" type="submit" value="{!SAVE}" />
		</p>
	</div>
</form>

