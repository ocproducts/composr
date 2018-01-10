<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{HIDDEN}

	<div class="installer_main_min">
		<p id="install_welcome">
			<strong>Welcome! &middot; Bienvenue! &middot; Willkommen! &middot; Bienvenidos! &middot; Welkom! &middot; Swaagatam! &middot; Irashaimasu! &middot; Huan yin! &middot; Dobro pozhalovat'! &middot; Witaj!</strong>
		</p>

		{+START,IF_NON_EMPTY,{WARNINGS}}
			{WARNINGS}
		{+END}

		<div class="wide-table-wrap"><table class="map-table form-table wide-table">
			<colgroup>
				<col class="installer_left_column" />
				<col class="installer_right_column" />
			</colgroup>

			<tbody>
				<tr>
					<th class="form-table-field-name">{!PLEASE_CHOOSE_LANG} (&dagger;)</th>
					<td class="form-table-field-input">
						<div class="accessibility-hidden"><label for="default_lang">{!PLEASE_CHOOSE_LANG}</label></div>
						<select id="default_lang" name="default_lang">
							{LANGUAGES}
						</select>
					</td>
				</tr>
			</tbody>
		</table></div>
	</div>

	<p class="proceed_button">
		<input class="button-screen buttons--proceed" data-disable-on-click="1" type="submit" value="{!PROCEED}" />
	</p>

	{+START,IF,{$EQ,{$SUBSTR_COUNT,{LANGUAGES},</option>},1}}
		<p>&dagger; Currently we do not directly ship additional languages with Composr. However community translations (made on Transifex) may be distributed in the addon directory.</p>
	{+END}
</form>
