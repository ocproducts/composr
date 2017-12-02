{$REQUIRE_JAVASCRIPT,authors}

<div data-tpl="authorPopup">
	{+START,IF_NON_EMPTY,{AUTHORS}}
		<ul class="compact_list">
			{+START,LOOP,AUTHORS}
				<li>
					<a href="#!" rel="nofollow" class="{$?,{DEFINED},author-defined,author-undefined} js-click-set-author-and-close" data-tp-field-name="{FIELD_NAME*}" data-tp-author="{AUTHOR*}">{AUTHOR*}</a>
				</li>
			{+END}
		</ul>
	{+END}
	{+START,IF_EMPTY,{AUTHORS}}
		<p class="nothing_here">
			{!NO_ENTRIES,author}
		</p>
	{+END}

	{+START,IF_PASSED,NEXT_URL}
		<hr />

		<nav>
			<ul class="actions_list">
				<li><a title="{!MORE}: {!AUTHORS}" href="{NEXT_URL*}">{!MORE}</a></li>
			</ul>
		</nav>
	{+END}
</div>
