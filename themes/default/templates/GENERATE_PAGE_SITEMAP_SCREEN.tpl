{TITLE}

<p>{!INTRO_GENERATE_PAGE_SITEMAP}</p>

<div class="generate-page-sitemap-screen">
	<div class="page-structure-wrap">
		{PAGE_STRUCTURE}
	</div>

	<p class="lonely-label">
		{!FILTER_BY_ZONE}:
	</p>
	<ul>
		{+START,IF,{$NEQ,{$GET,filter,none},none}}
			<li><a href="{$PAGE_LINK*,_SELF:_SELF:generate_page_sitemap}">{!NONE_EM}</a></li>
		{+END}
		{+START,LOOP,ZONES}
			<li><a href="{$PAGE_LINK*,_SELF:_SELF:generate_page_sitemap:filter={_loop_key}}">{_loop_var*}</a></li>
		{+END}
	</ul>
</div>
