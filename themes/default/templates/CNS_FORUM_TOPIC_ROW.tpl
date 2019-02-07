<tr>
	{+START,IF,{$DESKTOP}}
		{+START,IF,{$CONFIG_OPTION,is_on_topic_emoticons}}
			<td class="cns-forum-topic-row-emoticon cns-column1 cell-desktop">
				{+START,IF_NON_EMPTY,{EMOTICON}}
					<img class="vertical-alignment" alt="{EMOTICON*}" src="{$IMG*,{EMOTICON},1}" />
				{+END}
			</td>
		{+END}
	{+END}

	<td class="cns-forum-topic-row-preview cns-column2">
		{+START,IF,{$DESKTOP}}
			<div class="block-desktop">
				<a class="cns-forum-topic-row-preview-button" data-cms-tooltip="{ contents: '{$TRUNCATE_LEFT;^*,{POST},1000,0,1}', triggers: 'hover focus', width: '30%', delay: 0 }" href="{URL*}">{!PREVIEW} <span style="display: none">{ID*}</span></a>

				<div class="cns-forum-topic-title-bits">
					<span class="cns-forum-topic-title-bits-left">
						{+START,LOOP,TOPIC_ROW_LINKS}
							<a rel="nofollow" href="{URL*}" title="{$STRIP_TAGS,{ALT}}">{+START,INCLUDE,ICON}
								NAME=cns_topic_modifiers/{IMG}
								ICON_SIZE=14
							{+END}</a>
						{+END}

						{+START,LOOP,TOPIC_ROW_MODIFIERS}
							<a title="{ALT*}">{+START,INCLUDE,ICON}
								NAME=cns_topic_modifiers/{IMG}
								ICON_SIZE=14
							{+END}</a>
						{+END}
					</span>

					<a class="vertical-alignment{+START,IF,{UNREAD}} cns-unread-topic-title{+END}{+START,IF_NON_EMPTY,{TOPIC_ROW_MODIFIERS}{TOPIC_ROW_LINKS}} cns-forum-topic-indent{+END}" href="{URL*}" title="{$ALTERNATOR_TRUNCATED,{TITLE},60,{!TOPIC_STARTED_DATE_TIME,{HOVER;^}},,1}">{$TRUNCATE_LEFT,{TITLE},46,1}</a>

					{PAGES}

					{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
						<nav class="breadcrumbs" itemprop="breadcrumb"><p class="associated-details">{BREADCRUMBS}</p></nav>
					{+END}{+END}
				</div>
				{+START,IF_NON_EMPTY,{DESCRIPTION}}{+START,IF,{$NEQ,{TITLE},{DESCRIPTION}}}
					<div class="cns-forum-topic-description">{DESCRIPTION*}</div>
				{+END}{+END}
			</div>
		{+END}

		<div class="cell-mobile">
			<div class="cns-forum-topic-title-bits">
				<a class="vertical-alignment{+START,IF,{UNREAD}} cns-unread-topic-title{+END}{+START,IF_NON_EMPTY,{TOPIC_ROW_MODIFIERS}{TOPIC_ROW_LINKS}} cns-forum-topic-indent{+END}" href="{URL*}" title="{$ALTERNATOR_TRUNCATED,{TITLE},60,{!TOPIC_STARTED_DATE_TIME,{HOVER}},,1}">{$TRUNCATE_LEFT,{TITLE},46,1}</a>

				{PAGES}

				{+START,IF_PASSED,BREADCRUMBS}{+START,IF_NON_EMPTY,{BREADCRUMBS}}
					<nav class="breadcrumbs" itemprop="breadcrumb"><p class="associated-details">{BREADCRUMBS}</p></nav>
				{+END}{+END}
			</div>
			{+START,IF_NON_EMPTY,{DESCRIPTION}}{+START,IF,{$NEQ,{TITLE},{DESCRIPTION}}}
				<div class="cns-forum-topic-description">{DESCRIPTION*}</div>
			{+END}{+END}

			<div role="note">
				<ul class="horizontal-meta-details associated-details">
					<li><span class="field-name">{!COUNT_POSTS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}</li>
					<li><span class="field-name">{!COUNT_VIEWS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_VIEWS*}}</li>
				</ul>
				<span class="field-name">{!STARTER}:</span> {POSTER}
			</div>

			<div class="cns-forum-topic-title-bits-left">
				{+START,LOOP,TOPIC_ROW_LINKS}
					<a rel="nofollow" href="{URL*}" title="{$STRIP_TAGS,{ALT}}">{+START,INCLUDE,ICON}
						NAME=cns_topic_modifiers/{IMG}
						ICON_SIZE=14
					{+END}</a>
				{+END}

				{+START,LOOP,TOPIC_ROW_MODIFIERS}
					<a title="{ALT*}">{+START,INCLUDE,ICON}
						NAME=cns_topic_modifiers/{IMG}
						ICON_SIZE=14
					{+END}</a>
				{+END}
			</div>
		</div>
	</td>

	<td class="cns-forum-topic-row-poster cns-column3 cell-desktop">
		{POSTER}
	</td>

	{+START,IF,{$DESKTOP}}
		<td class="cns-forum-topic-row-num-posts cns-column4 cell-desktop">
			{$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}
		</td>
		{+START,IF,{$OR,{$EQ,{$LANG},EN},{$LT,{$LENGTH,{!COUNT_POSTS}{!COUNT_VIEWS}},12}}}
			<td class="cns-forum-topic-row-num-views cns-column5 cell-desktop">
				{$PREG_REPLACE,\,\d\d\d$,k,{NUM_VIEWS*}}
			</td>
		{+END}
	{+END}

	<td class="cns-forum-topic-row-last-post cns-column6">
		{LAST_POST}
	</td>

	{+START,IF,{$DESKTOP}}{+START,IF,{$NOT,{$_GET,overlay}}}
		{MARKER}
	{+END}{+END}
</tr>
