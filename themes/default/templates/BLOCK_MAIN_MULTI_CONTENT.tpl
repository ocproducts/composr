{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{+START,SET,links}
		{+START,IF_NON_EMPTY,{SUBMIT_URL}{ARCHIVE_URL}}
			<ul class="horizontal-links associated-links-block-group">
				{+START,IF_NON_EMPTY,{SUBMIT_URL}}
					<li><a rel="add" href="{SUBMIT_URL*}">{ADD_STRING*}</a></li>
				{+END}
				{+START,IF_NON_EMPTY,{CONTENT}}
					{+START,IF_NON_EMPTY,{ARCHIVE_URL}}
						<li><a href="{ARCHIVE_URL*}" title="{!ARCHIVES}: {TYPE*}">{!ARCHIVES}</a></li>
					{+END}
				{+END}
			</ul>
		{+END}
	{+END}

	{$,Example carousel layout if the 'carousel' GUID was passed}
	{$,With some basic templating you could also achieve simple lists or tables}
	{+START,IF,{$EQ,{_GUID},carousel}}
		{$REQUIRE_JAVASCRIPT,core_rich_media}
		{$REQUIRE_CSS,carousels}

		{$SET,carousel_id,{$RAND}}

		{+START,IF_NON_EMPTY,{CONTENT}}
			<div id="carousel-{$GET*,carousel_id}" class="carousel" style="display: none" data-view="Carousel" data-view-params="{+START,PARAMS_JSON,carousel_id}{_*}{+END}">
				<div class="move-left js-btn-car-move" data-move-amount="-30">{+START,INCLUDE,ICON}NAME=carousel/button_left{+END}</div>
				<div class="move-right js-btn-car-move" data-move-amount="+30">{+START,INCLUDE,ICON}NAME=carousel/button_right{+END}</div>

				<div class="main raw-ajax-grow-spot">
				</div>
			</div>

			<div class="carousel-temp" id="carousel-ns-{$GET*,carousel_id}">
				{+START,LOOP,CONTENT}
					{_loop_var}
				{+END}
			</div>
		{+END}

		{+START,IF_EMPTY,{CONTENT}}
			<p class="nothing-here">{!NO_ENTRIES,{CONTENT_TYPE}}</p>
		{+END}

		{$GET,links}
	{+END}

	{$,Normal sequential box layout}
	{$,With some very basic CSS you could also achieve grid layouts}
	{+START,IF,{$NEQ,{_GUID},carousel}}
		{+START,IF_NON_EMPTY,{TITLE}}
			<h2>{TITLE*}</h2>
		{+END}

		{$SET,ajax_block_main_multi_content_wrapper,ajax-block-main-multi-content-wrapper-{$RAND%}}
		{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}{+START,IF_PASSED,EXTRA_GET_PARAMS}{EXTRA_GET_PARAMS}{+END}&page={$PAGE&}}
		<div id="{$GET*,ajax_block_main_multi_content_wrapper}" class="box-wrapper" 
			  data-ajaxify="{ callUrl: '{$GET;*,block_call_url}', callParamsFromTarget: ['^[^_]*_start$', '^[^_]*_max$'], targetsSelector: '.ajax-block-wrapper-links a, .ajax-block-wrapper-links form' }">
			<div class="float-surrounder cguid-{_GUID|*} raw-ajax-grow-spot">
				{+START,IF_NON_EMPTY,{CONTENT}}
					{+START,LOOP,CONTENT}
						{_loop_var}
					{+END}
				{+END}

				{+START,IF_EMPTY,{CONTENT}}
					<p class="nothing-here">{!NO_ENTRIES,{CONTENT_TYPE}}</p>
				{+END}
			</div>

			{+START,IF_PASSED,PAGINATION}
				{+START,IF_NON_EMPTY,{PAGINATION}}
					<div class="pagination-spacing float-surrounder ajax-block-wrapper-links">
						{PAGINATION}
					</div>

					{+START,INCLUDE,AJAX_PAGINATION}
						WRAPPER_ID={$GET,ajax_block_main_multi_content_wrapper}
						ALLOW_INFINITE_SCROLL=1
					{+END}
				{+END}
			{+END}

			{$GET,links}
		</div>
	{+END}
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{+START,LOOP,CONTENT}
		{_loop_var}
	{+END}

	{+START,IF_PASSED,PAGINATION}
		{PAGINATION}
	{+END}
{+END}
