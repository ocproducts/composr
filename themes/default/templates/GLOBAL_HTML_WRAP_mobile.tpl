{+START,IF_NON_EMPTY,{$MESSAGES_TOP}}
	<div class="global_messages">
		{$MESSAGES_TOP}
	</div>
{+END}

<div class="float_surrounder">
	{+START,IF,{$NOT,{$IS_GUEST}}}
		{+START,IF_NON_EMPTY,{$LOAD_PANEL,panel_top}}
			<div id="panel_top" role="complementary">
				{$LOAD_PANEL,panel_top}
			</div>
		{+END}
	{+END}

	<article id="page_running_{$PAGE*}" class="zone_running_{$ZONE*} global_middle">
		{+START,IF_NON_EMPTY,{$BREADCRUMBS}}{+START,IF,{$IN_STR,{$BREADCRUMBS},<a }}{+START,IF,{$NEQ,{$ZONE}:{$PAGE},:start}}{+START,IF,{$SHOW_HEADER}}
			<nav class="global_breadcrumbs breadcrumbs" itemprop="breadcrumb" id="global_breadcrumbs">
				<img class="breadcrumbs_img" src="{$IMG*,1x/breadcrumbs}" srcset="{$IMG*,2x/breadcrumbs} 2x" title="{!YOU_ARE_HERE}" alt="{!YOU_ARE_HERE}" />
				{$BREADCRUMBS}
			</nav>
		{+END}{+END}{+END}{+END}

		<a id="maincontent"> </a>

		{MIDDLE}
	</article>

	{+START,IF_NON_EMPTY,{$TRIM,{$LOAD_PANEL,left}{$LOAD_PANEL,right}}}
		<div class="global_middle">
			<hr class="spaced_rule" />

			<h2>{!FEATURES}</h2>
		</div>

		{+START,IF_NON_EMPTY,{$TRIM,{$LOAD_PANEL,left}{$LOAD_PANEL,right}}}
			<div class="float_surrounder">
				<div class="global_side_panel panel_solo" role="complementary" itemscope="itemscope" itemtype="http://schema.org/WPSideBar">
					{$LOAD_PANEL,panel_left}
					{$LOAD_PANEL,panel_right}
				</div>
			</div>
		{+END}
	{+END}

	{+START,IF_NON_EMPTY,{$TRIM,{$LOAD_PANEL,bottom}}}
		<div id="panel_bottom" role="complementary">
			{$LOAD_PANEL,bottom}
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{$MESSAGES_BOTTOM}}
		<div class="global_messages">
			{$MESSAGES_BOTTOM}
		</div>
	{+END}
</div>
