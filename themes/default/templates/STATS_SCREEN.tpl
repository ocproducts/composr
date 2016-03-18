{TITLE}

{+START,IF,{$NOT,{$ISSET,SVG_ONCE}}}
	<div class="box svg_exp"><p class="box_inner">{!SVG_EXPLANATION}</p></div>
	{$SET,SVG_ONCE,1}
{+END}

{GRAPH}
<div class="link_exempt_wrap">
	{STATS}
</div>

{+START,IF_NON_PASSED_OR_FALSE,NO_CSV}
	<ul class="actions_list force_margin">
		<li><a href="{$EXTEND_URL*,{$SELF_URL},csv=1}" class="xls_link">{!EXPORT_STATS_TO_CSV}</a></li>
	</ul>
{+END}
