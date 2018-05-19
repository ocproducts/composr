<section class="box box---simple-preview-box"><div class="box-inner">
	{+START,IF_PASSED,TITLE}{+START,IF_NON_EMPTY,{TITLE}}
		<h3>
			{+START,IF_PASSED,FRACTIONAL_EDIT_FIELD_NAME}{+START,IF_PASSED,FRACTIONAL_EDIT_FIELD_URL}
				{+START,FRACTIONAL_EDITABLE,{TITLE_PLAIN},{FRACTIONAL_EDIT_FIELD_NAME},{FRACTIONAL_EDIT_FIELD_URL},0}{TITLE*}{+END}
			{+END}{+END}

			{+START,IF_NON_PASSED,FRACTIONAL_EDIT_FIELD_NAME}
				<a class="subtle-link" href="{URL*}">{TITLE*}</a>
			{+END}
		</h3>
	{+END}{+END}

	{+START,IF_PASSED,REP_IMAGE}
		<div class="right float-separation"><a href="{URL*}">{REP_IMAGE}</a></div>
	{+END}

	{+START,IF_NON_EMPTY,{SUMMARY}}
		<div class="float-surrounder">
			{$PARAGRAPH,{SUMMARY}}
		</div>
	{+END}

	{+START,IF_PASSED,ENTRY_DETAILS}
		<p class="associated-details">
			{$,Displays summary of category contents}
			({ENTRY_DETAILS})
		</p>
	{+END}
	{+START,IF_PASSED,ENTRY_DETAILS_PREBRACKETED}
		<p class="associated-details">
			{$,Displays summary of category contents}
			{ENTRY_DETAILS}
		</p>
	{+END}

	{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
		<nav class="breadcrumbs" itemprop="breadcrumb"><p>
			{!LOCATED_IN,{BREADCRUMBS}}
		</p></nav>
	{+END}{+END}

	{+START,IF_PASSED,URL}
		<p class="shunted-button">
			<a class="button-screen-item buttons--more" href="{URL*}"><span>{+START,INCLUDE,ICON}NAME=buttons/more{+END} {!VIEW}</span></a>
		</p>
	{+END}
</div></section>
