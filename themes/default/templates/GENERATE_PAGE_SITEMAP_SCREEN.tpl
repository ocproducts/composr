{TITLE}

<p>{!INTRO_GENERATE_PAGE_SITEMAP}</p>

<div class="generate_page_sitemap_screen">
	<div class="page_structure_wrap">
		{PAGE_STRUCTURE}
	</div>

	<p class="lonely_label">
		{!FILTER_BY_ZONE}:
	</p>
	<ul>
		<li><a href="{$PAGE_LINK*,_SELF:_SELF:generate_page_sitemap}">{!NONE_EM}</a></li>
		{+START,LOOP,ZONES}
			<li><a href="{$PAGE_LINK*,_SELF:_SELF:generate_page_sitemap:filter={_loop_key}}">{_loop_var*}</a></li>
		{+END}
	</ul>
</div>

