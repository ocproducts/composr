{$REQUIRE_JAVASCRIPT,cns_forum}

<tr data-require-javascript="cns_forum" data-tpl="cnsForumInGrouping" data-tpl-params="{+START,PARAMS_JSON,FORUM_RULES_URL,INTRO_QUESTION_URL}{_*}{+END}">
	{+START,IF,{$NOT,{$MOBILE}}}
		<td class="cns_forum_new_post_indicator cns_column1">
			<img width="32" height="32" title="{LANG_NEW_POST_OR_NOT*}" alt="{LANG_NEW_POST_OR_NOT*}" src="{$IMG*,cns_general/{NEW_POST_OR_NOT*}}" />
		</td>
	{+END}
	<td class="cns_forum_in_category_forum cns_column2">
		<a class="field_name" href="{FORUM_URL*}">{FORUM_NAME*}</a>

		{+START,IF_NON_EMPTY,{EDIT_URL}}
			<a class="horiz_field_sep associated_link suggested_link" rel="edit" href="{EDIT_URL*}" title="{!EDIT}: {FORUM_NAME*}">{!EDIT}</a>
		{+END}
		{+START,IF_NON_EMPTY,{FORUM_RULES_URL}}
			<a class="horiz_field_sep associated_link suggested_link js-click-open-forum-rules-popup" target="_blank" data-click-pd="1" href="{FORUM_RULES_URL*}" title="{!FORUM_RULES}: {FORUM_NAME*} {!LINK_NEW_WINDOW}">{!FORUM_RULES}</a>
		{+END}
		{+START,IF_NON_EMPTY,{INTRO_QUESTION_URL}}
			<a class="horiz_field_sep associated_link suggested_link js-click-open-intro-question-popup" target="_blank" data-click-pd="1" href="{INTRO_QUESTION_URL*}" title="{!INTRO_QUESTION}: {FORUM_NAME*} {!LINK_NEW_WINDOW}">{!INTRO_QUESTION}</a>
		{+END}

		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<div class="cns_forum_description">
				{DESCRIPTION}
			</div>
		{+END}

		{+START,IF_NON_EMPTY,{SUBFORUMS}}
			<div class="cns_forum_subforums">
				<p><span class="field_name">{!SUBFORUMS}:</span> {SUBFORUMS}</p>
			</div>
		{+END}

		{+START,IF,{$MOBILE}}
			<div role="note">
				<ul class="horizontal_meta_details associated_details">
					<li><span class="field_name">{!COUNT_TOPICS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_TOPICS*}}</li>
					<li><span class="field_name">{!COUNT_POSTS}:</span> {$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}</li>
				</ul>
			</div>
		{+END}
	</td>
	{+START,IF,{$NOT,{$MOBILE}}}
		<td class="cns_forum_num_topics cns_column4">
			{$PREG_REPLACE,\,\d\d\d$,k,{NUM_TOPICS*}}
		</td>
		<td class="cns_forum_num_posts cns_column5">
			{$PREG_REPLACE,\,\d\d\d$,k,{NUM_POSTS*}}
		</td>
	{+END}
	<td class="cns_forum_latest cns_column6">
		{LATEST}
	</td>
</tr>
