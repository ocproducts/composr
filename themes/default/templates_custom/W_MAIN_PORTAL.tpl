<div>
	<a href="{$PAGE_LINK*,_SELF:_SELF:portal:param={DEST_REALM}}">{NAME*}</a>

	{+START,IF,{EDITABLE}}
		&ndash; <a title="{!EDIT}: #{NAME*}" href="{$PAGE_LINK*,_SELF:_SELF:editportal:param={DEST_REALM}}">{!EDIT}</a>
		&ndash; <form class="inline" action="{$PAGE_LINK*,_SELF:_SELF:confirm:btype=deleteportal:param={DEST_REALM}}" method="post" autocomplete="off"><input class="button-hyperlink" type="submit" value="{!DELETE}" /></form>
	{+END}
</div>
