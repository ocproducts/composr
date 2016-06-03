{TITLE}

{+START,IF_EMPTY,{CONTENT_TESTS}{CONTENT_COMPETITIONS}{CONTENT_SURVEYS}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_NON_EMPTY,{CONTENT_TESTS}{CONTENT_COMPETITIONS}{CONTENT_SURVEYS}}
	<div itemprop="significantLinks">
		{+START,IF_NON_EMPTY,{CONTENT_TESTS}}
			<h2>{!TESTS}</h2>

			{CONTENT_TESTS}
		{+END}

		{+START,IF_NON_EMPTY,{CONTENT_COMPETITIONS}}
			<h2>{!COMPETITIONS}</h2>

			{CONTENT_COMPETITIONS}
		{+END}

		{+START,IF_NON_EMPTY,{CONTENT_SURVEYS}}
			<h2>{!SURVEYS}</h2>

			{CONTENT_SURVEYS}
		{+END}
	</div>

	{+START,IF_NON_EMPTY,{PAGINATION}}
		<div class="pagination_spacing float_surrounder">
			{PAGINATION}
		</div>
	{+END}
{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,cms_quiz}}{$PAGE_LINK*,cms:cms_quiz:add}{+END}
	1_TITLE={!ADD_QUIZ}
	1_REL=add
	1_ICON=menu/_generic_admin/add_one
{+END}
