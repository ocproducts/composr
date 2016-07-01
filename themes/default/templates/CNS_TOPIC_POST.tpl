<div>
	<div class="cns_forum_box_left{+START,IF_NON_EMPTY,{CLASS}} {CLASS*}{+END}">
		<h2 class="accessibility_hidden">
			{!FORUM_POST}
		</h2>

		{EMPHASIS*}

		{+START,IF_NON_EMPTY,{ID}}<a id="post_{ID*}"></a>{+END}

		{FIRST_UNREAD}
	</div>

	<div class="cns_forum_box_right cns_post_details" role="note">
		<div class="cns_post_details_date">
			{$SET,post_date,<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{POST_DATE_RAW}}">{POST_DATE*}</time>}
			{$?,{$MOBILE},{$GET,post_date},{!POSTED_TIME_SIMPLE,{$GET,post_date}}}
		</div>

		{+START,IF_NON_EMPTY,{POSTER}}
			{+START,IF_PASSED,RATING}
				<div class="cns_post_details_rating">
					<div class="accessibility_hidden">{!RATING}:</div>
					{RATING}
				</div>
			{+END}

			{+START,IF_NON_EMPTY,{UNVALIDATED}}
				<div class="cns_post_details_unvalidated">
					{UNVALIDATED*}
				</div>
			{+END}
		{+END}

		<div class="cns_post_details_grapple">
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
	</div>
</div>

<div>
	<div class="cns_topic_post_member_details" role="note">
		{+START,IF_NON_EMPTY,{POSTER}}
			<div class="cns_topic_poster_name">
				{POSTER}
			</div>

			<div>
				{POST_AVATAR}
				{+START,IF_NON_EMPTY,{POSTER_TITLE}}<div class="cns_topic_poster_title">{POSTER_TITLE*}</div>{+END}
				{+START,IF_NON_EMPTY,{RANK_IMAGES}}<div class="cns_topic_poster_rank_images">{RANK_IMAGES}</div>{+END}
			</div>
		{+END}
	</div>

	<div class="cns_topic_post_area cns_post_main_column">
		<div class="float_surrounder">
			{+START,IF,{$NOT,{$MOBILE}}}
				{+START,IF,{$JS_ON}}{+START,IF_NON_EMPTY,{ID}}{+START,IF_NON_PASSED_OR_FALSE,PREVIEWING}
					<div id="cell_mark_{ID*}" class="cns_off mass_select_marker">
						<form class="webstandards_checker_off" title="{!FORUM_POST} {!MARKER} #{ID*}" method="post" action="index.php" id="form_mark_{ID*}" autocomplete="off">
							{$INSERT_SPAMMER_BLACKHOLE}

							<div>
								{+START,IF,{$NOT,{$IS_GUEST}}}<div class="accessibility_hidden"><label for="mark_{ID*}">{!FORUM_POST} {!MARKER} #{ID*}</label></div>{+END}{$,Guests don't see this so search engines don't; hopefully people with screen-readers are logged in}
								<input{+START,IF,{$NOT,{$IS_GUEST}}} title="{!FORUM_POST} {!MARKER} #{ID*}"{+END} value="1" type="checkbox" id="mark_{ID*}" name="mark_{ID*}" onclick="change_class(this,'cell_mark_{ID*}','cns_on mass_select_marker','cns_off mass_select_marker')" />
							</div>
						</form>
					</div>
				{+END}{+END}{+END}
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
				<hr class="cns_sig_barrier" />

				<div class="cns_member_signature">
					{SIGNATURE}
				</div>
			</div>
		{+END}
	</div>
</div>

<div>
	<div class="cns_left_post_buttons {CLASS*}">
		{EMPHASIS*}

		{+START,IF,{$NOT,{GIVE_CONTEXT}}}
			{+START,IF_EMPTY,{EMPHASIS}}{+START,IF_NON_EMPTY,{ID}}
				<div class="cns_post_back_to_top">
					{$,is on/offline}
					{+START,IF,{$NOT,{$VALUE_OPTION,no_member_tracking}}}
						{+START,IF_PASSED,POSTER_ONLINE}
							<img title="{!ONLINE_NOW}: {$?,{POSTER_ONLINE},{!YES},{!NO}}" alt="{!ONLINE_NOW}: {$?,{POSTER_ONLINE},{!YES},{!NO}}" src="{$IMG*,1x/cns_general/{$?,{POSTER_ONLINE},ison,isoff}}" srcset="{$IMG*,1x/cns_general/{$?,{POSTER_ONLINE},ison,isoff}} 2x" />
						{+END}
					{+END}

					<a href="#" rel="back_to_top"><img title="{!BACK_TO_TOP}" alt="{!BACK_TO_TOP}" src="{$IMG*,icons/24x24/tool_buttons/top}" srcset="{$IMG*,icons/48x48/tool_buttons/top} 2x" /></a>
				</div>
			{+END}{+END}
		{+END}
	</div>

	<div class="buttons_group post_buttons cns_post_main_column">
		{BUTTONS}
	</div>
</div>
