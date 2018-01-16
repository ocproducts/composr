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
	<div class="wide-table-wrap"><table class="map-table form-table wide-table import_actions">
		{+START,IF,{$DESKTOP}}
			<colgroup>
				<col class="field-name-column" />
				<col class="field-input-column" />
			</colgroup>
		{+END}

		<tbody>
			{IMPORT_LIST}
		</tbody>
	</table></div>

	<p class="proceed-button">
		<input accesskey="u" data-disable-on-click="1" class="button-screen buttons--proceed" type="submit" value="{!IMPORT}" />
	</p>
</form>

{+START,IF_NON_EMPTY,{MESSAGE}}
	<hr class="spaced-rule" />

	<section class="box"><div class="box-inner">
		<p>{MESSAGE*}</p>
	</div></section>
{+END}
