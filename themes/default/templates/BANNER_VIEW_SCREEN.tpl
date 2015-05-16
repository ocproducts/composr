{TITLE}

<h2>{!DETAILS}</h2>

{MAP_TABLE}

<h2>{!VIEW}</h2>

<p>
	{!BANNER_LOOKS}
</p>

{$PARAGRAPH,{BANNER}}

{$REVIEW_STATUS,banner,{NAME}}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={EDIT_URL*}
	1_TITLE={!EDIT}
	1_ACCESSKEY=q
	1_REL=edit
	1_ICON=menu/_generic_admin/edit_this
{+END}
