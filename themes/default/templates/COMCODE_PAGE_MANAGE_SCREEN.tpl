<div>
	{TITLE}

	{$PARAGRAPH,{TEXT}}

	{TABLE}

	<form title="{!PRIMARY_PAGE_FORM}" action="{POST_URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{HIDDEN}

		{+START,IF,{HAS_PAGINATION}}
			<p>
				<label for="filter">{!FILTER}:</label>
				<input type="text" id="filter" class="form-control" name="filter" value="{FILTER*}" data-submit-on-enter="1" />
				<button class="btn btn-primary btn-sm buttons--filter" type="submit">{+START,INCLUDE,ICON}NAME=buttons/filter{+END} {!FILTER}</button>
			</p>
		{+END}
	</form>

	<h2 class="force_margin">{!COMCODE_PAGE_ADD}</h2>

	<a id="comcode_page_add"></a>

	{+START,IF_PASSED,EXTRA}
		{EXTRA}
	{+END}
	{+START,IF_NON_PASSED,EXTRA}
		<p>{!ACCESS_DENIED}</p>
	{+END}

	{+START,IF_NON_EMPTY,{LINKS}}
		<h2>{!ADVANCED}</h2>

		<ul class="actions-list">
			{+START,LOOP,LINKS}
				<li style="background-image: url('{LINK_IMAGE;*}'); background-size: 18px 18px; background-position: 0 0; padding-left: 20px"><a href="{LINK_URL*}">{LINK_TEXT*}</a></li>
			{+END}
		</ul>
	{+END}
</div>
