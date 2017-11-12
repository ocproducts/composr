{$REQUIRE_JAVASCRIPT,core_rich_media}

<div data-toggleable-tray="{}" class="box box___standardbox_accordion accordion_trayitem js-tray-accordion-item{+START,IF_PASSED,CLASS} {CLASS*}{+END}"{+START,IF_NON_EMPTY,{WIDTH}} style="width: {WIDTH*}"{+END}>
	{+START,IF_NON_EMPTY,{TITLE}}
		<h3 class="toggleable_tray_title js-btn-tray-accordion">
			{+START,IF_NOT_IN_ARRAY,OPTIONS,tray_open}
				<a class="toggleable_tray_button js-btn-tray-accordion" href="#!"><img alt="{!EXPAND}: {$STRIP_TAGS,{TITLE}}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
			{+END}
			{+START,IF_IN_ARRAY,OPTIONS,tray_open}
				<a class="toggleable_tray_button js-btn-tray-accordion" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{TITLE}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>
			{+END}

			{+START,IF_NON_EMPTY,{TOP_LINKS}}
				{TOP_LINKS}
			{+END}

			<a class="toggleable_tray_button js-btn-tray-accordion" href="#!">{TITLE}</a>
		</h3>
	{+END}
	<div class="toggleable_tray"{+START,IF_NOT_IN_ARRAY,OPTIONS,tray_open} style="display: none" aria-expanded="false"{+END}>
		{+START,IF_NON_EMPTY,{META}}
			<div class="meta_details" role="note">
				<dl class="meta_details_list">
					{+START,LOOP,META}
						<dt class="field_name">{KEY}:</dt> <dd>{VALUE}</dd>
					{+END}
				</dl>
			</div>
		{+END}

		{$PARAGRAPH,{CONTENT}}

		{+START,IF_NON_EMPTY,{LINKS}}
			<ul class="horizontal_links associated_links_block_group">
				{+START,LOOP,LINKS}
					<li>{_loop_var}</li>
				{+END}
			</ul>
		{+END}
	</div>
</div>
