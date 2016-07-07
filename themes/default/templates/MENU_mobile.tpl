{$REQUIRE_CSS,menu__mobile}
{$REQUIRE_JAVASCRIPT,menu_mobile}

{+START,IF_NON_EMPTY,{CONTENT}}
	<a href="{$PAGE_LINK*,:sitemap}" class="mobile_menu_button" onclick="return mobile_menu_button('{MENU|;*}');"><img src="{$IMG*,mobile_menu}" alt="{!MENU}" /> <span>{!MENU}</span></a>

	<nav class="menu_type__mobile" style="display: none" aria-expanded="false">
		<div class="mobile_search">
			{$BLOCK,block=top_search,failsafe=1}
		</div>

		<ul class="nl" id="r_{MENU|*}_d">
			{CONTENT}
		</ul>

	{+START,IF_PASSED_AND_TRUE,JAVASCRIPT_HIGHLIGHTING}
		<script>// <![CDATA[
			menu_active_selection('r_{MENU|}_d');
		//]]></script>
	{+END}
	</nav>
{+END}
