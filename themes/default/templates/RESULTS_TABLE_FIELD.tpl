<td>
	{$SET,edit_link,{$AND,{$NOT,{$IN_STR,{VALUE},<img,<p}},{$IN_STR,{VALUE},{!EDIT}</a>}}}
	{+START,IF,{$GET,edit_link}}<img src="{$IMG*,icons/14x14/edit}" srcset="{$IMG*,icons/28x28/edit} 2x" alt="" />&nbsp;<strong>{VALUE}</strong>{+END}
	{+START,IF,{$NOT,{$GET,edit_link}}}{VALUE}{+END}
</td>
