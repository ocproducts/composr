{+START,IF_ARRAY_NON_EMPTY,CHILDREN}
	<div class="box box---block-main-comcode-page-children" data-tpl="blockMainComcodePageChildren"><div class="box-inner">
		<p class="lonely-label">{!CHILD_PAGES}:</p>
		<ul class="spaced-list">
			{+START,LOOP,CHILDREN}
				<li>
					<a href="{$PAGE_LINK*,{ZONE}:{PAGE}}">{TITLE*}</a>
				</li>
			{+END}
		</ul>
	</div></div>
{+END}

{$SET,has_comcode_page_children_block,1}
