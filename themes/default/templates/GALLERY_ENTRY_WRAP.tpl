{+START,IF,{$EQ,{_GUID},carousel}}
	{ENTRY}
{+END}

{+START,IF,{$NEQ,{_GUID},carousel}}
	<div class="gallery_grid_cell">
		{ENTRY}
	</div>
{+END}

