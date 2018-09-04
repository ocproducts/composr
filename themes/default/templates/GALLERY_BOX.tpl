<div class="box box---gallery-box"><div class="box-inner">
	{+START,SET,content_box_title}
		{+START,IF,{GIVE_CONTEXT}}
			{!CONTENT_IS_OF_TYPE,{!GALLERY},{TITLE*}}
		{+END}

		{+START,IF,{$NOT,{GIVE_CONTEXT}}}
			{+START,FRACTIONAL_EDITABLE,{TITLE},fullname,_SEARCH:cms_galleries:__edit_category:{ID}}{TITLE*}{+END}
		{+END}
	{+END}
	{+START,IF,{$NOT,{$GET,skip_content_box_title}}}
		<h3>{+START,IF_NON_EMPTY,{URL}}<a class="subtle-link" href="{URL*}">{+END}{$GET,content_box_title}{+START,IF_NON_EMPTY,{URL}}</a>{+END}</h3>
	{+END}

	{+START,IF_NON_EMPTY,{THUMB}}
		<div class="right float-separation">
			<a href="{URL*}">{$TRIM,{THUMB}}</a>
		</div>
	{+END}

	{+START,IF_PASSED,DESCRIPTION}{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<p class="associated-details">{$TRUNCATE_LEFT,{DESCRIPTION},100,0,1}</p>
	{+END}{+END}

	<p class="associated-details">
		{$,Displays summary of gallery contents}
		({LANG})
	</p>

	{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
		<nav class="breadcrumbs" itemprop="breadcrumb"><p>
			{!LOCATED_IN,{BREADCRUMBS}}
		</p></nav>
	{+END}{+END}

	<div class="buttons-group proceed-button-left">
		<a class="btn btn-primary btn-scri buttons--more" href="{URL*}"><span>{+START,INCLUDE,ICON}NAME=buttons/more{+END} {!VIEW}</span></a>
	</div>
</div></div>
