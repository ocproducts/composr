<div class="box box___gallery_box"><div class="box_inner">
	{+START,SET,content_box_title}
		{+START,IF,{GIVE_CONTEXT}}
			{!CONTENT_IS_OF_TYPE,{!GALLERY},{TITLE*}}
		{+END}

		{+START,IF,{$NOT,{GIVE_CONTEXT}}}
			{+START,FRACTIONAL_EDITABLE,{TITLE},fullname,_SEARCH:cms_galleries:__edit_category:{ID}}{TITLE*}{+END}
		{+END}
	{+END}
	{+START,IF,{$NOT,{$GET,skip_content_box_title}}}
		<h3>{$GET,content_box_title}</h3>
	{+END}

	{+START,IF_NON_EMPTY,{THUMB}}
		<div class="right float_separation">
			<a href="{URL*}">{$TRIM,{THUMB}}</a>
		</div>
	{+END}

	{+START,IF_PASSED,DESCRIPTION}{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<p class="associated_details">{$TRUNCATE_LEFT,{DESCRIPTION},100,0,1}</p>
	{+END}{+END}

	<p class="associated_details">
		{$,Displays summary of gallery contents}
		({LANG})
	</p>

	{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
		<nav class="breadcrumbs" itemprop="breadcrumb"><p>
			{!LOCATED_IN,{BREADCRUMBS}}
		</p></nav>
	{+END}{+END}

	<div class="buttons_group proceed_button_left">
		<a class="button_screen_item buttons__more" href="{URL*}"><span>{!VIEW}</span></a>
	</div>
</div></div>
