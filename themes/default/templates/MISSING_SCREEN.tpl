{TITLE}

<p>
	{!MISSING_PAGE,{PAGE*}}
</p>

{+START,IF_PASSED,DID_MEAN}
	<p>
		{!WERE_YOU_LOOKING_FOR,<a href="{$PAGE_LINK*,{$ZONE}:{DID_MEAN}}">{DID_MEAN*}</a>}
	</p>
{+END}

{+START,SET,BUTTONS}
	{+START,IF_NON_EMPTY,{ADD_URL}}
		<a class="button-screen admin--add" rel="add" href="{ADD_URL*}"><span>{!ADD_NEW_PAGE}</span></a>
	{+END}

	{+START,IF_PASSED,ADD_REDIRECT_URL}
		{+START,IF_NON_EMPTY,{ADD_REDIRECT_URL}}
			<a class="button-screen buttons--redirect" href="{ADD_REDIRECT_URL*}"><span>{!redirects:NEW_REDIRECT}</span></a>
		{+END}
	{+END}
{+END}
{+START,IF_NON_EMPTY,{$TRIM,{$GET,BUTTONS}}}
	<div class="float-surrounder">
		<div class="trinav-left">
			<p class="buttons-group">
				{$GET,BUTTONS}
			</p>
		</div>
	</div>
{+END}

{+START,IF_NON_PASSED,SKIP_SITEMAP}
	<h2>{!SITEMAP}</h2>

	{$REQUIRE_CSS,menu__sitemap}
	{$REQUIRE_JAVASCRIPT,core_menus}
	{$BLOCK-,block=menu,param=\,use_page_groupings=1,type=sitemap,quick_cache=1}

	{+START,IF,{$ADDON_INSTALLED,search}}
		<h2>{!SEARCH}</h2>

		<div class="constrain-search-block">
			{$BLOCK,block=main_search,failsafe=1}
		</div>
	{+END}
{+END}
