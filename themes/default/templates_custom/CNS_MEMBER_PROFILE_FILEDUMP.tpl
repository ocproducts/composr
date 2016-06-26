{$BLOCK,block=myfiles,member_id={MEMBER_ID}}

{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,filedump}}
	<p class="associated_link associated_links_block_group"><a href="{$PAGE_LINK*,_SEARCH:filedump:browse:place=/{$USERNAME&}/}">{!MORE}</a></p>
{+END}
