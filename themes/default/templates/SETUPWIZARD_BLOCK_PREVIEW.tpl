<div class="float_surrounder">
	{+START,IF_NON_EMPTY,{LEFT}}
		<div id="panel_left" class="global_side_panel" role="complementary" itemscope="itemscope" itemtype="http://schema.org/WPSideBar">
			{$COMCODE,{LEFT}}
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{LEFT}}
		<div id="panel_right" class="global_side_panel" role="complementary" itemscope="itemscope" itemtype="http://schema.org/WPSideBar">
			{$COMCODE,{RIGHT}}
		</div>
	{+END}

	<article class="global_middle">
		{$COMCODE,{START}}
	</article>
</div>
