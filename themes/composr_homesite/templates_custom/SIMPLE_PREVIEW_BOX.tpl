{+START,IF,{$EQ,{RESOURCE_TYPE},download_category}}
	<div class="downloads-cat-box">
		<div class="downloads-cat-box-img">
			{+START,IF_PASSED,REP_IMAGE}
				<a href="{URL*}">{REP_IMAGE}</a>
			{+END}
		</div>

		<div class="downloads-cat-box-title">
			<a href="{URL*}">{TITLE*}</a><br />

			<span>
				{+START,IF_NON_EMPTY,{SUMMARY}}
					{$TRUNCATE_LEFT,{$STRIP_TAGS,{SUMMARY}},85,0,1}<br />
				{+END}

				{+START,IF_PASSED,ENTRY_DETAILS}
					({ENTRY_DETAILS})
				{+END}
				{+START,IF_PASSED,ENTRY_DETAILS_PREBRACKETED}
					{ENTRY_DETAILS}
				{+END}
			</span>
		</div>
	</div>
{+END}

{+START,IF,{$NEQ,{RESOURCE_TYPE},download_category}}
	<section class="box box___simple_preview_box"><div class="box_inner">
		{+START,IF_PASSED,TITLE}{+START,IF_NON_EMPTY,{TITLE}}
			<h3>
				{+START,IF_PASSED,FRACTIONAL_EDIT_FIELD_NAME}{+START,IF_PASSED,FRACTIONAL_EDIT_FIELD_URL}
					{+START,FRACTIONAL_EDITABLE,{TITLE_PLAIN},{FRACTIONAL_EDIT_FIELD_NAME},{FRACTIONAL_EDIT_FIELD_URL},0}{TITLE*}{+END}
				{+END}{+END}

				{+START,IF_NON_PASSED,FRACTIONAL_EDIT_FIELD_NAME}
					{TITLE*}
				{+END}
			</h3>
		{+END}{+END}

		{+START,IF_PASSED,REP_IMAGE}
			<div class="right float_separation"><a href="{URL*}">{REP_IMAGE}</a></div>
		{+END}

		{+START,IF_NON_EMPTY,{SUMMARY}}
			<div class="float_surrounder">
				{$PARAGRAPH,{SUMMARY}}
			</div>
		{+END}

		{+START,IF_PASSED,ENTRY_DETAILS}
			<p class="associated_details">
				{$,Displays summary of category contents}
				({ENTRY_DETAILS})
			</p>
		{+END}
		{+START,IF_PASSED,ENTRY_DETAILS_PREBRACKETED}
			<p class="associated_details">
				{$,Displays summary of category contents}
				{ENTRY_DETAILS}
			</p>
		{+END}

		{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
			<nav class="breadcrumbs" itemprop="breadcrumb" role="navigation"><p>
				{!LOCATED_IN,{BREADCRUMBS}}
			</p></nav>
		{+END}{+END}

		{+START,IF_PASSED,URL}
			<p class="shunted_button">
				<a class="buttons__more button_screen_item" href="{URL*}"><span>{!VIEW}</span></a>
			</p>
		{+END}
	</div></section>
{+END}
