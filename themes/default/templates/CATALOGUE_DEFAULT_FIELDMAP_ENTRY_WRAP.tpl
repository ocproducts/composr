{$,Read the catalogue tutorial for information on custom catalogue layouts}

{+START,IF,{GIVE_CONTEXT}}
<div class="box"><div class="box-inner">
{+END}
{+START,IF,{$NOT,{GIVE_CONTEXT}}}
<div class="catalogue-fieldmap-entry-wrap">
{+END}
	{+START,IF,{GIVE_CONTEXT}}
		<h3>{!CATALOGUE_GENERIC,{CATALOGUE_TITLE*}}</h3>
	{+END}

	<div class="wide-table-wrap"><table class="map-table wide-table results-table spaced-table responsive-blocked-table">
		{+START,IF,{$DESKTOP}}
			<colgroup>
				<col class="catalogue-fieldmap-field-name-column" />
				<col class="catalogue-fieldmap-field-value-column" />
			</colgroup>
		{+END}

		<tbody>
			{$SET,just_done_title,}
			{FIELDS}
		</tbody>
	</table></div>

	{+START,IF_PASSED,BREADCRUMBS}
		{+START,IF_NON_EMPTY,{BREADCRUMBS}}
			<nav class="breadcrumbs" itemprop="breadcrumb"><p>{!LOCATED_IN,{BREADCRUMBS}}</p></nav>
		{+END}
	{+END}

	{+START,IF_NON_PASSED_OR_FALSE,ENTRY_SCREEN}
		<div class="float-surrounder">
			{+START,IF,{$NOT,{GIVE_CONTEXT}}}
				<p class="left">
					<a rel="back_to_top" target="_self" href="#!"><img class="back-to-top-by-buttons" title="{!BACK_TO_TOP}" alt="{!BACK_TO_TOP}" width="24" height="24" src="{$IMG*,icons/48x48/tool_buttons/top}" /></a>
				</p>
			{+END}

			{+START,IF_NON_EMPTY,{VIEW_URL}}
				<p class="{$?,{GIVE_CONTEXT},shunted-button,right}">
					<a class="button-screen-item buttons--more" title="{!VIEW}{+START,IF_PASSED,FIELD_0}: {$STRIP_TAGS*,{FIELD_0}}{+START,IF_PASSED_AND_TRUE,COMMENT_COUNT} ({$STRIP_TAGS,{$COMMENT_COUNT,catalogues,{ID}}}){+END}{+END}" href="{VIEW_URL*}"><span>{!VIEW}</span></a>
				</p>
			{+END}
			{+START,IF_EMPTY,{VIEW_URL}}{+START,IF_NON_EMPTY,{EDIT_URL}}
				<p class="{$?,{GIVE_CONTEXT},shunted-button,right}">
					<a class="button-screen-item buttons--edit" href="{EDIT_URL*}" title="{!EDIT}{+START,IF_PASSED,FIELD_0}: {$STRIP_TAGS*,{FIELD_0}}{+END}"><span>{!EDIT}</span></a>
				</p>
			{+END}{+END}
		</div>
	{+END}
{+START,IF,{$NOT,{GIVE_CONTEXT}}}
</div>
{+END}
{+START,IF,{GIVE_CONTEXT}}
</div></div>
{+END}
