{$REQUIRE_JAVASCRIPT,cns_forum}

<tr data-tpl="cnsForumInGrouping" data-tpl-params="{+START,PARAMS_JSON,FORUM_RULES_URL,INTRO_QUESTION_URL}{_*}{+END}">
	{+START,IF,{$DESKTOP}}
		<td class="cns-forum-new-post-indicator cns-column1 cell-desktop">
			<a title="{LANG_NEW_POST_OR_NOT*}">{+START,INCLUDE,ICON}
				NAME=cns_general/{NEW_POST_OR_NOT*}
				ICON_SIZE=32
			{+END}</a>
		</td>
	{+END}
	<td class="cns-forum-in-category-forum cns-column2">
		<a class="field-name" href="{FORUM_URL*}">{FORUM_NAME*}</a>

		{+START,IF_NON_EMPTY,{EDIT_URL}}
			<a class="horiz-field-sep associated-link suggested-link" rel="edit" href="{EDIT_URL*}" title="{!EDIT}: {FORUM_NAME*}">{!EDIT}</a>
		{+END}
		{+START,IF_NON_EMPTY,{FORUM_RULES_URL}}
			<a class="horiz-field-sep associated-link suggested-link js-click-open-forum-rules-popup" target="_blank" data-click-pd="1" href="{FORUM_RULES_URL*}" title="{!FORUM_RULES}: {FORUM_NAME*} {!LINK_NEW_WINDOW}">{!FORUM_RULES}</a>
		{+END}
		{+START,IF_NON_EMPTY,{INTRO_QUESTION_URL}}
			<a class="horiz-field-sep associated-link suggested-link js-click-open-intro-question-popup" target="_blank" data-click-pd="1" href="{INTRO_QUESTION_URL*}" title="{!INTRO_QUESTION}: {FORUM_NAME*} {!LINK_NEW_WINDOW}">{!INTRO_QUESTION}</a>
		{+END}

		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<div class="cns-forum-description">
				{DESCRIPTION}
			</div>
		{+END}

		{+START,IF_NON_EMPTY,{SUBFORUMS}}
			<div class="cns-forum-subforums">
				<p><span class="field-name">{!SUBFORUMS}:</span> {SUBFORUMS}</p>
			</div>
		{+END}

		<div role="note" class="block-mobile">
			<ul class="horizontal-meta-details associated-details">
				<li><span class="field-name">{!COUNT_TOPICS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_TOPICS*}}</li>
				<li><span class="field-name">{!COUNT_POSTS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}</li>
			</ul>
		</div>
	</td>
	{+START,IF,{$DESKTOP}}
		<td class="cns-forum-num-topics cns-column4 cell-desktop">
			{$PREG_REPLACE,\,\d\d\d$,k,{NUM_TOPICS*}}
		</td>
		<td class="cns-forum-num-posts cns-column5 cell-desktop">
			{$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}
		</td>
	{+END}
	<td class="cns-forum-latest cns-column6">
		{LATEST}
	</td>
</tr>
