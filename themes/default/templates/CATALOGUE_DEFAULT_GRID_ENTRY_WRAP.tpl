<section class="box box___catalogue_default_grid_entry_wrap"><div class="box_inner">
	<h3><span class="name">{$TRUNCATE_LEFT,{FIELD_0},25,1,1}</h3>

	{+START,SET,TOOLTIP}
		{+START,IF_NON_EMPTY,{$TRIM,{FIELDS_GRID}}}
			<table class="map_table results_table">
				<tbody>
					{FIELDS_GRID}
				</tbody>
			</table>
		{+END}
	{+END}

	{$SET,displayed_thumb,0}

	{$SET,view_url,{$?,{$AND,{$MOBILE},{$IS_NON_EMPTY,{FIELDS_GRID}}},{$PAGE_LINK,_SELF:catalogues:entry:{ID}},{VIEW_URL}}}

	{+START,IF_PASSED,FIELD_1_THUMB}
		{+START,IF_NON_EMPTY,{FIELD_1_THUMB}}
			<div class="catalogue-entry-box-thumbnail">
				{+START,IF_NON_EMPTY,{$GET,view_url}}
					<a data-mouseover-activate-tooltip="['{$TRIM*;^,{$GET,TOOLTIP}}','500px']" href="{$GET*,view_url}">{FIELD_1_THUMB}</a>
				{+END}

				{+START,IF_EMPTY,{$GET,view_url}}
					<span data-mouseover-activate-tooltip="['{$TRIM*;^,{$GET,TOOLTIP}}','500px']">{FIELD_1_THUMB}</span>
				{+END}
			</div>

			{$SET,displayed_thumb,1}
		{+END}
	{+END}

	{+START,IF,{$NOT,{$GET,displayed_thumb}}}
		{+START,IF_NON_EMPTY,{$GET,view_url}}
			<p>
				<a data-mouseover-activate-tooltip="['{$TRIM*;^,{$GET,TOOLTIP}}','500px']" href="{$GET*,view_url}">{!VIEW}</a>
			</p>
		{+END}

		{+START,IF_EMPTY,{$GET,view_url}}
			{$GET,TOOLTIP}
		{+END}
	{+END}

	{+START,IF,{ALLOW_RATING}}{+START,IF_NON_EMPTY,{$TRIM,{RATING}}}
		<div class="ratings">
			{RATING}
		</div>
	{+END}{+END}
</div></section>
