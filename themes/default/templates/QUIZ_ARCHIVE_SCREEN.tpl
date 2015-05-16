{TITLE}

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
