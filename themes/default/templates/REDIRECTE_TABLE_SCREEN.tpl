{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

<p>
	{!TEXT_REDIRECTS}
</p>

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<h2>{!EXISTING_REDIRECTS}</h2>

	<div class="wide_table_wrap"><table class="columned_table wide_table redirect_table results_table">
		<colgroup>
			<col class="redirect_table_input_column" />
			<col class="redirect_table_input_column" />
			<col class="redirect_table_input_column" />
			<col class="redirect_table_input_column" />
			<col class="redirect_table_sup_column" />
			<col class="redirect_table_sup_column" />
		</colgroup>

		<thead>
			<tr>
				<th>
					{!REDIRECT_FROM_ZONE}
				</th>
				<th>
					{!REDIRECT_FROM_PAGE}
				</th>
				<th>
					{!REDIRECT_TO_ZONE}
				</th>
				<th>
					{!REDIRECT_TO_PAGE}
				</th>
				<th>
					<abbr title="{$STRIP_TAGS,{!IS_TRANSPARENT_REDIRECT}}">{!REDIRECT_TRANS_SHORT}</abbr>
				</th>
				<th>
				</th>
			</tr>
		</thead>
		<tbody>
			{FIELDS}
		</tbody>
	</table></div>

	<h2>{!NEW_REDIRECT}</h2>

	<div class="wide_table_wrap"><table class="columned_table wide_table redirect_table results_table">
		<colgroup>
			<col class="redirect_table_input_column" />
			<col class="redirect_table_input_column" />
			<col class="redirect_table_input_column" />
			<col class="redirect_table_input_column" />
			<col class="redirect_table_sup_column" />
			<col class="redirect_table_sup_column" />
		</colgroup>

		<thead>
			<tr>
				<th>
					{!REDIRECT_FROM_ZONE}
				</th>
				<th>
					{!REDIRECT_FROM_PAGE}
				</th>
				<th>
					{!REDIRECT_TO_ZONE}
				</th>
				<th>
					{!REDIRECT_TO_PAGE}
				</th>
				<th>
					<abbr title="{$STRIP_TAGS,{!IS_TRANSPARENT_REDIRECT}}">{!REDIRECT_TRANS_SHORT}</abbr>
				</th>
				<th>
				</th>
			</tr>
		</thead>
		<tbody>
			{NEW}
		</tbody>
	</table></div>

	<p class="proceed_button">
		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__save" type="submit" value="{!SAVE}" />
	</p>

	<hr class="spaced_rule" />

	<div class="box box___redirecte_table_screen"><div class="box_inner">
		<h2>{!NOTES}</h2>

		<p>
			<label for="m_notes">{!NOTES_ABOUT_REDIRECTS}</label>
		</p>

		<div class="constrain_field">
			<textarea class="wide_field" id="m_notes" name="notes" cols="50" rows="10">{NOTES*}</textarea>
		</div>
	</div></div>
</form>
