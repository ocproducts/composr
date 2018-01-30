{$REQUIRE_JAVASCRIPT,core_cns}
{$REQUIRE_JAVASCRIPT,cns_forum}

<div class="cns-topic-post" data-tpl="cnsTopicPost" data-tpl-params="{+START,PARAMS_JSON,ID}{_*}{+END}">
	<div class="cns-topic-section cns-topic-header">
		<div class="cns-forum-box-left{+START,IF_NON_EMPTY,{CLASS}} {CLASS*}{+END}">
			<h2 class="accessibility-hidden">
				{!FORUM_POST}
			</h2>

			{EMPHASIS*}

			{+START,IF_NON_EMPTY,{ID}}<a id="post_{ID*}"></a>{+END}

			{FIRST_UNREAD}
		</div>

		<div class="cns-forum-box-right cns-post-details" role="note">
			<div class="cns-post-details-date">
				{$SET,post_date,<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{POST_DATE_RAW}}">{POST_DATE*}</time>}
				{+START,IF,{$DESKTOP}}<span class="inline-desktop">{!POSTED_TIME_SIMPLE,{$GET,post_date}}</span>{+END}<span class="inline-mobile">{$GET,post_date}</span>
			</div>

			{+START,IF_NON_EMPTY,{POSTER}}
				{+START,IF_PASSED,RATING}
					<div class="cns-post-details-rating">
						<div class="accessibility-hidden">{!RATING}:</div>
						{RATING}
					</div>
				{+END}

				{+START,IF_NON_EMPTY,{UNVALIDATED}}
					<div class="cns-post-details-unvalidated">
						{UNVALIDATED*}
					</div>
				{+END}
			{+END}

			{+START,IF,{$DESKTOP}}
				<div class="cns-post-details-grapple block-desktop">
					{+START,IF_NON_EMPTY,{URL}}
						{+START,IF_NON_EMPTY,{POST_ID*}}
							<a href="{URL*}" rel="nofollow">#{POST_ID*}</a>
						{+END}
					{+END}
					{+START,IF,{$EQ,{ID},{TOPIC_FIRST_POST_ID},}}{+START,IF_NON_EMPTY,{TOPIC_ID}}
						{+START,IF_NON_EMPTY,{POST_ID}}({!IN,{!FORUM_TOPIC_NUMBERED,{TOPIC_ID*}}}){+END}
						{+START,IF_EMPTY,{POST_ID}}{!FORUM_TOPIC_NUMBERED,{TOPIC_ID*}}{+END}
					{+END}{+END}
				</div>
			{+END}
		</div>
	</div>

	<div class="cns-topic-section cns-topic-body">
		<div class="cns-topic-post-member-details" role="note">
			{+START,IF_NON_EMPTY,{POSTER}}
				<div class="cns-topic-poster-name">
					{POSTER}
				</div>

				<div>
					{POST_AVATAR}
					{+START,IF_NON_EMPTY,{POSTER_TITLE}}<div class="cns-topic-poster-title">{POSTER_TITLE*}</div>{+END}
					{+START,IF_NON_EMPTY,{RANK_IMAGES}}<div class="cns-topic-poster-rank-images">{RANK_IMAGES}</div>{+END}
				</div>
			{+END}
		</div>

		<div class="cns-topic-post-area cns-post-main-column">
			<div class="float-surrounder">
				{+START,IF,{$DESKTOP}}
					{+START,IF_NON_EMPTY,{ID}}{+START,IF_NON_PASSED_OR_FALSE,PREVIEWING}
						<div id="cell_mark_{ID*}" class="cns-off mass-select-marker block-desktop">
							<form class="webstandards-checker-off" title="{!FORUM_POST} {!MARKER} #{ID*}" method="post" action="index.php" id="form_mark_{ID*}" autocomplete="off">
								{$INSERT_SPAMMER_BLACKHOLE}

								<div>
									{+START,IF,{$NOT,{$IS_GUEST}}}<div class="accessibility-hidden"><label for="mark_{ID*}">{!FORUM_POST} {!MARKER} #{ID*}</label></div>{+END}{$,Guests don't see this so search engines don't; hopefully people with screen-readers are logged in}
									<input {+START,IF,{$NOT,{$IS_GUEST}}} title="{!FORUM_POST} {!MARKER} #{ID*}"{+END} value="1" type="checkbox" id="mark_{ID*}" name="mark_{ID*}" class="js-click-checkbox-set-cell-mark-class" />
								</div>
							</form>
						</div>
					{+END}{+END}
				{+END}

				{+START,IF_NON_EMPTY,{POST_TITLE}}{+START,IF,{$NEQ,{TOPIC_FIRST_POST_ID},{ID}}}
					<h3>
						{POST_TITLE*}
					</h3>
				{+END}{+END}

				{+START,IF_PASSED,DESCRIPTION}{+START,IF_NON_EMPTY,{DESCRIPTION}}{+START,IF,{$NEQ,{DESCRIPTION},{POST_TITLE}}}
					<h3>
						{DESCRIPTION*}
					</h3>
				{+END}{+END}{+END}

				{POST}
			</div>

			{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,post,{ID}}}
			{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}
				{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry},1}
			{+END}

			{LAST_EDITED}

			{$,Content reviews for posts is bloat for 99.99% of people but enable it if you want it {$REVIEW_STATUS,post,{ID}}}

			{+START,IF_NON_EMPTY,{SIGNATURE}}
				<div>
					<hr class="cns-sig-barrier" />

					<div class="cns-member-signature">
						{SIGNATURE}
					</div>
				</div>
			{+END}
		</div>
	</div>

	<div class="cns-topic-section cns-topic-footer">
		<div class="cns-left-post-buttons {CLASS*}">
			{EMPHASIS*}

			{+START,IF,{$NOT,{GIVE_CONTEXT}}}
				{+START,IF_EMPTY,{EMPHASIS}}{+START,IF_NON_EMPTY,{ID}}
					<div class="cns-post-back-to-top">
						{$,is on/offline}
						{+START,IF,{$NOT,{$VALUE_OPTION,no_member_tracking}}}
							{+START,IF_PASSED,POSTER_ONLINE}
								<img title="{!ONLINE_NOW}: {$?,{POSTER_ONLINE},{!YES},{!NO}}" alt="{!ONLINE_NOW}: {$?,{POSTER_ONLINE},{!YES},{!NO}}" width="14" height="14" src="{$IMG*,1x/cns_general/{$?,{POSTER_ONLINE},ison,isoff}}" />
							{+END}
						{+END}

						<a href="#!" rel="back_to_top"><img title="{!BACK_TO_TOP}" alt="{!BACK_TO_TOP}" width="24" height="24" src="{$IMG*,icons/48x48/tool_buttons/top}" /></a>
					</div>
				{+END}{+END}
			{+END}
		</div>

		<div class="buttons-group post-buttons cns-post-main-column">
			{BUTTONS}
		</div>
	</div>
</div>
