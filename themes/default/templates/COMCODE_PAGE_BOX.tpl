{+START,SET,PREVIEW_CONTENTS}
	{+START,IF_NON_EMPTY,{SUMMARY}}
		<div class="float_surrounder">
			{$TRUNCATE_LEFT,{SUMMARY},300,0,1}
		</div>
	{+END}

	{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
		<nav class="breadcrumbs" itemprop="breadcrumb"><p>
			{!LOCATED_IN,{BREADCRUMBS}}
		</p></nav>
	{+END}{+END}

	<p class="shunted_button">
		<a class="button_screen_item buttons__more" href="{URL*}"><span>{!VIEW}</span></a>
	</p>
{+END}

{+START,IF_PASSED,TITLE}
	<section class="box box___comcode_page_box"><div class="box_inner">
		{+START,SET,content_box_title}
			{+START,IF,{GIVE_CONTEXT}}
				{!CONTENT_IS_OF_TYPE,{!PAGE},{TITLE*}}
			{+END}

			{+START,IF,{$NOT,{GIVE_CONTEXT}}}
				{TITLE*}
			{+END}
		{+END}
		{+START,IF,{$NOT,{$GET,skip_content_box_title}}}
			<h3>{$GET,content_box_title}</h3>
		{+END}

		{$GET,PREVIEW_CONTENTS}
	</div></section>
{+END}

{+START,IF_NON_PASSED,TITLE}
	{$GET,PREVIEW_CONTENTS}
{+END}
