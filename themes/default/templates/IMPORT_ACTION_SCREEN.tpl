{TITLE}

{+START,IF_EMPTY,{EXTRA}}
	<p>{!IMPORT_WARNING}</p>
{+END}

{+START,IF_NON_EMPTY,{EXTRA}}
	<ul>
		{EXTRA}
	</ul>
{+END}

{$REQUIRE_CSS,forms}

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{HIDDEN}

	<p>{!SELECT_TO_IMPORT}</p>
	<div class="wide_table_wrap"><table class="map_table form_table wide_table import_actions">
		{+START,IF,{$NOT,{$MOBILE}}}
			<colgroup>
				<col class="field_name_column" />
				<col class="field_input_column" />
			</colgroup>
		{+END}

		<tbody>
			{IMPORT_LIST}
		</tbody>
	</table></div>

	<p class="proceed_button">
		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__proceed" type="submit" value="{!IMPORT}" />
	</p>
</form>

{+START,IF_NON_EMPTY,{MESSAGE}}
	<hr class="spaced_rule" />

	<section class="box"><div class="box_inner">
		<p>{MESSAGE*}</p>
	</div></section>
{+END}
