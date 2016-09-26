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

	{+START,IF_PASSED,FIELD_1_THUMB}
		{+START,IF_NON_EMPTY,{FIELD_1_THUMB}}
			<div class="catalogue_entry_box_thumbnail">
				{+START,IF_NON_EMPTY,{VIEW_URL}}
					<a onmouseover="activate_tooltip(this, event, '{$TRIM*;^,{$GET,TOOLTIP}}','500px');" href="{VIEW_URL*}">{FIELD_1_THUMB}</a>
				{+END}

				{+START,IF_EMPTY,{VIEW_URL}}
					<span onmouseover="activate_tooltip(this, event, '{$TRIM*;^,{$GET,TOOLTIP}}','500px');">{FIELD_1_THUMB}</span>
				{+END}
			</div>

			{$SET,displayed_thumb,1}
		{+END}
	{+END}

	{+START,IF,{$NOT,{$GET,displayed_thumb}}}
		{+START,IF_NON_EMPTY,{VIEW_URL}}
			<p>
				<a onmouseover="activate_tooltip(this, event, '{$TRIM*;^,{$GET,TOOLTIP}}','500px');" href="{VIEW_URL*}">{!VIEW}</a>
			</p>
		{+END}

		{+START,IF_EMPTY,{VIEW_URL}}
			{$GET,TOOLTIP}
		{+END}
	{+END}

	{+START,IF,{ALLOW_RATING}}
		<div class="ratings">
			{RATING}
		</div>
	{+END}
</div></section>
