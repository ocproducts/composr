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
		<a class="button_screen menu___generic_admin__add_one" rel="add" href="{ADD_URL*}"><span>{!ADD_NEW_PAGE}</span></a>
	{+END}

	{+START,IF_PASSED,ADD_REDIRECT_URL}
		{+START,IF_NON_EMPTY,{ADD_REDIRECT_URL}}
			<a class="button_screen buttons__redirect" href="{ADD_REDIRECT_URL*}"><span>{!redirects:NEW_REDIRECT}</span></a>
		{+END}
	{+END}
{+END}
{+START,IF_NON_EMPTY,{$TRIM,{$GET,BUTTONS}}}
	<div class="float_surrounder">
		<div class="trinav_left">
			<p class="buttons_group">
				{$GET,BUTTONS}
			</p>
		</div>
	</div>
{+END}

{+START,IF_NON_PASSED,SKIP_SITEMAP}
	<h2>{!SITEMAP}</h2>

	{$BLOCK,block=menu,param=\,use_page_groupings=1,type=sitemap,quick_cache=1}

	{+START,IF,{$ADDON_INSTALLED,search}}
		<h2>{!SEARCH}</h2>

		<div class="constrain_search_block">
			{$BLOCK,block=main_search,failsafe=1}
		</div>
	{+END}
{+END}
