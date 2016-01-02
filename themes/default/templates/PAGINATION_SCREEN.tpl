{TITLE}

{+START,IF_PASSED,DESCRIPTION}
	<div>{DESCRIPTION}</div>
{+END}

{+START,IF_PASSED,SUB_TITLE}
	<h2>{SUB_TITLE}</h2>
{+END}

{+START,IF_NON_EMPTY,{CONTENT}}
	{CONTENT}
{+END}
{+START,IF_EMPTY,{CONTENT}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_PASSED,PAGINATION}
	{+START,IF_NON_EMPTY,{PAGINATION}}
		<div class="pagination_spacing float_surrounder">
			{PAGINATION}
		</div>
	{+END}
{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	{+START,IF_PASSED,ADD_URL}
		1_URL={ADD_URL*}
		1_TITLE={!ADD}
		1_REL=add
		1_ICON=menu/_generic_admin/add_one
	{+END}
	{+START,IF_PASSED,EDIT_URL}
		2_URL={EDIT_URL*}
		2_TITLE={+START,IF_PASSED,EDIT_LABEL}{EDIT_LABEL*}{+END}{+START,IF_NON_PASSED,EDIT_LABEL}{!EDIT}{+END}
		2_REL=edit
		2_ICON=menu/_generic_admin/edit_this
	{+END}
	{+START,IF_PASSED,ADD_CAT_URL}{+START,IF_PASSED,ADD_CAT_TITLE}
		3_URL={ADD_CAT_URL*}
		3_TITLE={ADD_CAT_TITLE*}
		3_REL=add
		3_ICON=menu/_generic_admin/add_one_category
	{+END}{+END}
{+END}
