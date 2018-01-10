<div class="global-middle-outer float-surrounder">
	<article class="global-middle">
		{$COMCODE,{START}}
	</article>

	{+START,IF_NON_EMPTY,{LEFT}}
		<div id="panel-left" class="global-side-panel" role="complementary" itemscope="itemscope" itemtype="http://schema.org/WPSideBar">
			{$COMCODE,{LEFT}}
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{RIGHT}}
		<div id="panel-right" class="global-side-panel" role="complementary" itemscope="itemscope" itemtype="http://schema.org/WPSideBar">
			{$COMCODE,{RIGHT}}
		</div>
	{+END}
</div>
