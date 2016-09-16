<tr>
	{+START,IF,{$NOT,{$MOBILE}}}
		{+START,IF,{$CONFIG_OPTION,is_on_topic_emoticons}}
			<td class="cns_forum_topic_row_emoticon cns_column1">
				{+START,IF_NON_EMPTY,{EMOTICON}}
					<img class="vertical_alignment" alt="{EMOTICON*}" src="{$IMG*,{EMOTICON},1}" />
				{+END}
			</td>
		{+END}
	{+END}

	<td class="cns_forum_topic_row_preview cns_column2">
		{+START,IF,{$NOT,{$MOBILE}}}
			<a class="cns_forum_topic_row_preview_button" onblur="this.onmouseout(event);" onfocus="this.onmouseover(event);" onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{$TRUNCATE_LEFT*~;^,{POST},1000,0,1}','30%',null,null,null,true);" href="{URL*}">{!PREVIEW} <span style="display: none">{ID*}</span></a>

			<div class="cns_forum_topic_title_bits">
				<span class="cns_forum_topic_title_bits_left">
					{+START,LOOP,TOPIC_ROW_LINKS}
						<a rel="nofollow" href="{URL*}"><img class="vertical_alignment" src="{$IMG*,icons/14x14/cns_topic_modifiers/{IMG}}" srcset="{$IMG*,icons/28x28/cns_topic_modifiers/{IMG}} 2x" title="{$STRIP_TAGS,{ALT}}" alt="{$STRIP_TAGS,{ALT}}" /></a>
					{+END}

					{+START,LOOP,TOPIC_ROW_MODIFIERS}
						<img class="vertical_alignment" src="{$IMG*,icons/14x14/cns_topic_modifiers/{IMG}}" srcset="{$IMG*,icons/28x28/cns_topic_modifiers/{IMG}} 2x" title="{ALT*}" alt="{ALT*}" />
					{+END}
				</span>

				<a class="vertical_alignment {+START,IF_NON_EMPTY,{TOPIC_ROW_MODIFIERS}{TOPIC_ROW_LINKS}} cns_forum_topic_indent{+END}" href="{URL*}" title="{$ALTERNATOR_TRUNCATED,{TITLE},60,{!TOPIC_STARTED_DATE_TIME,{HOVER;~}},,1}">{+START,IF,{UNREAD}}<span class="cns_unread_topic_title">{+END}{$TRUNCATE_LEFT,{TITLE},46,1}{+START,IF,{UNREAD}}</span>{+END}</a>

				{PAGES}

				{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
					<nav class="breadcrumbs" itemprop="breadcrumb"><p class="associated_details">{BREADCRUMBS}</p></nav>
				{+END}{+END}
			</div>
			{+START,IF_NON_EMPTY,{DESCRIPTION}}{+START,IF,{$NEQ,{TITLE},{DESCRIPTION}}}
				<div class="cns_forum_topic_description">{DESCRIPTION*}</div>
			{+END}{+END}
		{+END}

		{+START,IF,{$MOBILE}}
			<div class="cns_forum_topic_title_bits">
				<a class="vertical_alignment {+START,IF_NON_EMPTY,{TOPIC_ROW_MODIFIERS}{TOPIC_ROW_LINKS}} cns_forum_topic_indent{+END}" href="{URL*}" title="{$ALTERNATOR_TRUNCATED,{TITLE},60,{!TOPIC_STARTED_DATE_TIME,{HOVER;~}},,1}">{+START,IF,{UNREAD}}<span class="cns_unread_topic_title">{+END}{$TRUNCATE_LEFT,{TITLE},46,1}{+START,IF,{UNREAD}}</span>{+END}</a>

				{PAGES}

				{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
					<nav class="breadcrumbs" itemprop="breadcrumb"><p class="associated_details">{BREADCRUMBS}</p></nav>
				{+END}{+END}
			</div>
			{+START,IF_NON_EMPTY,{DESCRIPTION}}{+START,IF,{$NEQ,{TITLE},{DESCRIPTION}}}
				<div class="cns_forum_topic_description">{DESCRIPTION*}</div>
			{+END}{+END}

			<div role="note">
				<ul class="horizontal_meta_details associated_details">
					<li><span class="field_name">{!COUNT_POSTS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}</li>
					<li><span class="field_name">{!COUNT_VIEWS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_VIEWS*}}</li>
				</ul>
			</div>

			<div class="cns_forum_topic_title_bits_left">
				{+START,LOOP,TOPIC_ROW_LINKS}
					<a rel="nofollow" href="{URL*}"><img class="vertical_alignment" src="{$IMG*,icons/14x14/cns_topic_modifiers/{IMG}}" srcset="{$IMG*,icons/28x28/cns_topic_modifiers/{IMG}} 2x" title="{$STRIP_TAGS,{ALT}}" alt="{$STRIP_TAGS,{ALT}}" /></a>
				{+END}

				{+START,LOOP,TOPIC_ROW_MODIFIERS}
					<img class="vertical_alignment" src="{$IMG*,icons/14x14/cns_topic_modifiers/{IMG}}" srcset="{$IMG*,icons/28x28/cns_topic_modifiers/{IMG}} 2x" title="{ALT*}" alt="{ALT*}" />
				{+END}
			</div>
		{+END}
	</td>

	<td class="cns_forum_topic_row_poster cns_column3">
		{POSTER}
	</td>

	{+START,IF,{$NOT,{$MOBILE}}}
		<td class="cns_forum_topic_row_num_posts cns_column4">
			{$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}
		</td>
		{+START,IF,{$OR,{$EQ,{$LANG},EN},{$LT,{$LENGTH,{!COUNT_POSTS}{!COUNT_VIEWS}},12}}}
			<td class="cns_forum_topic_row_num_views cns_column5">
				{$PREG_REPLACE,\,\d\d\d$,k,{NUM_VIEWS*}}
			</td>
		{+END}
	{+END}

	<td class="cns_forum_topic_row_last_post cns_column6">
		{LAST_POST}
	</td>

	{+START,IF,{$NOT,{$MOBILE}}}{+START,IF,{$NOT,{$_GET,overlay}}}
		{MARKER}
	{+END}{+END}
</tr>

