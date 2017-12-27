<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off" data-tpl="installerStep3">
	{HIDDEN}

	<div class="installer_main_min">
		<p>
			{!WELCOME_A,<a title="{!WELCOME_B} {!LINK_NEW_WINDOW}" rel="external" href="{$TUTORIAL_URL*,tut_install}" target="_blank">{!WELCOME_B}</a>}
		</p>

		<p>
			{!FORUM_CHOICE}
		</p>

		<table class="columned_table installer_forums">
			<tbody>
				<tr>
					<th class="de_th">
						<div class="left">
							{!FORUM_SOFTWARE}
						</div>
					</th>

					<th class="de_th">
						<div class="right">
							{!FORUM_VERSION}
						</div>
					</th>
				</tr>
				<tr>
					<td class="installer_forum_list">
						{FORUMS}
					</td>

					<td class="installer_forum_version">
						<div id="versions">
							{VERSION}
						</div>
					</td>
				</tr>
			</tbody>
		</table>

		<p style="display: none" id="forum_database_info">
			{!CAREFUL}
		</p>

		{+START,IF,{$NOT,{$GOOGLE_APPENGINE}}}
			<div id="forum_path" style="display: none">
				<p>{!FORUM_PATH_TEXT}</p>
				<div class="wide-table-wrap"><table class="map_table form_table wide-table">
					<colgroup>
						<col class="installer_input_left_column" />
						<col class="installer_input_right_column" />
					</colgroup>

					<tbody>
						<tr>
							<th class="form_table_field_name">{!FORUM_PATH}</th>
							<td class="form_table_field_input">
								<div class="accessibility_hidden"><label for="board_path">{!_FORUM_PATH}</label></div>
								<div><input class="wide_field" type="text" size="60" id="board_path" name="board_path" value="{FORUM_PATH_DEFAULT*}" /></div>
							</td>
						</tr>
					</tbody>
				</table></div>
			</div>

			<div class="float-surrounder">
				<p class="lonely_label">
					<a class="toggleable-tray-button js-click-toggle-advanced-db-setup-section" data-tp-section="{!ADVANCED_DATABASE_SETUP~|*}" href="#!">{!ADVANCED_DATABASE_SETUP}</a>
					<a class="toggleable-tray-button js-click-toggle-advanced-db-setup-section" data-tp-section="{!ADVANCED_DATABASE_SETUP~|*}" href="#!"><img id="img_{!ADVANCED_DATABASE_SETUP|*}" alt="{!EXPAND}: {$STRIP_TAGS,{!ADVANCED_DATABASE_SETUP}}" title="{!EXPAND}" src="{$BASE_URL*}/install.php?type=expand" /></a>
				</p>

				<div id="{!ADVANCED_DATABASE_SETUP|*}" style="display: none">
					<div class="wide-table-wrap"><table class="map_table form_table wide-table">
						<colgroup>
							<col class="installer_left_column" />
							<col class="installer_right_column" />
						</colgroup>

						<tbody>
							<tr>
								<th class="form_table_field_name">{!USE_MULTI_DB} <div class="associated-details">{!REQUIRES_MORE_INFO}</div></th>
								<td class="form_table_field_input">
									<label for="yes"><input type="radio" name="use_multi_db" value="1" id="yes" />{!YES}</label>
									<label class="radio_horiz_spacer" for="no"><input type="radio" name="use_multi_db" value="0" id="no" checked="checked" />{!NO}</label>
								</td>
							</tr>

							<tr>
								<th class="form_table_field_name">{!USE_MSN} <div class="associated-details">{!REQUIRES_MORE_INFO}</div></th>
								<td class="form_table_field_input">
									<label for="yes2"><input type="radio" name="use_msn" value="1" id="yes2" />{!YES}</label>
									<label class="radio_horiz_spacer" for="no2"><input type="radio" name="use_msn" value="0" id="no2" checked="checked" />{!NO}</label>
								</td>
							</tr>
						</tbody>
					</table></div>
				</div>
			</div>
		{+END}

		<p>
			<label for="db_type">{!DB_CHOICE}</label>:
			<select id="db_type" name="db_type">
				{DATABASES}
			</select>
		</p>
	</div>

	<p class="proceed_button">
		<input class="button_screen buttons--proceed" data-disable-on-click="1" type="submit" value="{!PROCEED}" />
	</p>
</form>
