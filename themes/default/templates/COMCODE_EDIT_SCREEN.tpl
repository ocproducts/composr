{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

{TEXT}

{POSTING_FORM}

{+START,IF,{$NOT,{NEW}}}
	<div class="buttons_group">
		<a class="menu___generic_admin__delete button_screen_item" href="{DELETE_URL*}"><span>{!DELETE}: {ZONE*}:{FILE*}</span></a>
	</div>
{+END}

{REVISION_HISTORY}

