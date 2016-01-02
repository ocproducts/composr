<ul class="page_structure">
	{+START,LOOP,PAGE_STRUCTURE}
		<li>
			{!PAGE}: <kbd><a href="{EDIT_URL*}">{ZONE_NAME*}:{PAGE_NAME*}</a></kbd>{+START,IF_NON_EMPTY,{PAGE_TITLE}} (&ldquo;{PAGE_TITLE`}&rdquo;){+END}
			<span class="page_state">
				{+START,IF,{$NOT,{VALIDATED}}}<span>&#10007; {!UNVALIDATED}</span>{+END}
				{+START,IF,{TODO}}<span>&#10007; {!UNDER_CONSTRUCTION}</span>{+END}
			</span>

			{+START,IF_NON_EMPTY,{MENU_PATHS}}
				<ul class="menu_links">
					{+START,LOOP,MENU_PATHS}
						<li>
							<img width="17" height="17" class="vertical_alignment" alt="" src="{$IMG*,1x/menus/menu}" srcset="{$IMG*,2x/menus/menu} 2x" /> <kbd><a href="{MENU_URL*}">{MENU*}</a></kbd> (<span class="breadcrumbs"><span>{+START,IMPLODE,</span> <span class="sep"><span class="accessibility_hidden"> &rarr;</span></span> <span>,MENU_PATH_COMPONENTS,0,1}{+END}</span></span>)
						</li>
					{+END}
				</ul>
			{+END}

			{CHILDREN}
		</li>
	{+END}
</ul>

