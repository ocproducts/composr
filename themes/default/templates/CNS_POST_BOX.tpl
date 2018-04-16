<div class="cns-post-box">
	<div class="wide-table-wrap"><div class="wide-table cns-topic">
			{POST}
	</div></div>

	{+START,IF_PASSED,BREADCRUMBS}
		<nav class="breadcrumbs" itemprop="breadcrumb"><p>
			{!LOCATED_IN,{BREADCRUMBS}}
		</p></nav>

		{+START,IF_PASSED,URL}
			<p class="shunted-button">
				<a class="button-screen-item buttons--more" href="{URL*}" title="{!FORUM_POST} #{ID*}"><span>{!VIEW}</span> {+START,INCLUDE,ICON}NAME=buttons/more{+END}</a>
			</p>
		{+END}
	{+END}
</div>
