{+START,SET,cell}
	{$SET,edit_link,{$AND,{$NOT,{$IN_STR,{VALUE},<img,<p,<ul}},{$IN_STR,{VALUE},{!EDIT}</a>}}}
	{+START,IF,{$GET,edit_link}}
		{+START,INCLUDE,ICON}
			NAME=admin/edit
			SIZE=14
		{+END}
		&nbsp;<strong>{VALUE}</strong>
	{+END}
	{+START,IF,{$NOT,{$GET,edit_link}}}{VALUE}{+END}
{+END}
{$,We trim so ":empty" will work in CSS, used by our responsive tables}
<td{+START,IF_PASSED,COLSPAN} colspan="{COLSPAN*}"{+END}>{$TRIM,{$GET,cell}}</td>
