<div>
	<div class="cns_forum_box_left cns_forum_box_right cns_post_details" role="note">
		<a id="post_{ID*}"></a>

		<div class="wiki_topic_poster_name">
			{+START,IF_NON_EMPTY,{POSTER_URL}}
				{!CONTENT_BY,<a href="{POSTER_URL*}">{$DISPLAYED_USERNAME*,{POSTER}}</a>}
			{+END}
			{+START,IF_EMPTY,{POSTER_URL}}
				{!CONTENT_BY,{POSTER*}}
			{+END}
		</div>

		<div class="cns_post_details_date">
			{!POSTED_TIME_SIMPLE,<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{POST_DATE_RAW}}">{POST_DATE*}</time>}
		</div>

		{+START,IF_NON_EMPTY,{UNVALIDATED}}
			<div class="cns_post_details_unvalidated">
				{UNVALIDATED*}
			</div>
		{+END}
	</div>
</div>
<div>
	<div class="cns_topic_post_area cns_post_main_column wiki_topic_post_area" id="pe_{ID*}">
		{POST}

		{$REVIEW_STATUS,wiki_post,{ID}}
	</div>
</div>
{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,wiki_post,{ID}}}
{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry},1}{+END}
{+START,IF_NON_EMPTY,{BUTTONS}}
	<div>
		<div class="cns_left_post_buttons post_buttons cns_post_main_column">
			<div class="buttons_group post_buttons wiki_post_buttons">
				{BUTTONS}

				{+START,IF,{$AND,{$JS_ON},{STAFF_ACCESS}}}
					<div id="cell_mark_{ID*}" class="cns_off mass_select_marker wiki_mass_select_marker">
						<form class="webstandards_checker_off" title="{!MARKER}: {ID*}" method="post" action="index.php" id="form_mark_{ID*}" autocomplete="off">
							<div>
								{+START,IF,{$NOT,{$IS_GUEST}}}<label for="mark_{ID*}">{!MARKER}<span class="accessibility_hidden"> #{ID*}</span>:</label>{+END}{$,Guests don't see this so search engines don't; hopefully people with screen-readers are logged in}
								<input onclick="var button=document.getElementById('wiki_merge_button'); button.className=button.className.replace(' button_faded',''); button.style.display='inline';"{+START,IF,{$NOT,{$IS_GUEST}}} title="{!MARKER} #{ID*}"{+END} value="1" type="checkbox" id="mark_{ID*}" name="mark_{ID*}" onclick="change_class(this,'cell_mark_{ID*}','cns_on mass_select_marker','cns_off mass_select_marker')" />
							</div>
						</form>
					</div>
				{+END}
			</div>

			{+START,SET,commented_out}
				{+START,IF,{$EQ,{$CONFIG_OPTION,is_on_rating},1}}
					<div class="wiki_post_below">
						<form title="{!RATING}" class="inline" action="{RATE_URL*}" method="post" autocomplete="off">
							{$INSERT_SPAMMER_BLACKHOLE}

							{RATING}
						</form>
					</div>
				{+END}
			{+END}
		</div>
	</div>
{+END}
