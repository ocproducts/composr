<section id="tray_{!MEMBER|}" class="box cns_information_bar_outer">
	<h2 class="toggleable_tray_title">
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!MEMBER|}');"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!MEMBER}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode,false,'{!MEMBER|}');">{!MEMBER_INFORMATION,{$USERNAME*,{$MEMBER},1}}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,search}} / {!SEARCH}{+END}</a>
	</h2>

	<div class="toggleable_tray">
		<div class="cns_information_bar float_surrounder">
			{+START,IF_NON_EMPTY,{AVATAR_URL}}
				<div{+START,IF,{$NOT,{$MOBILE}}} style="min-height: {$MAX,100,{MAX_AVATAR_HEIGHT|}}px"{+END} class="cns_member_column cns_member_column_a">
					<img alt="{!AVATAR}" title="{!AVATAR}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{AVATAR_URL}}" />
				</div>
			{+END}

			<div{+START,IF,{$NOT,{$MOBILE}}} style="min-height: {$MAX,100,{MAX_AVATAR_HEIGHT|}}px"{+END} class="cns_member_column cns_member_column_b">
				<p class="cns_member_column_title">{!WELCOME_BACK,<a href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>}</p>
				{+START,IF,{$NOT,{$IS_HTTPAUTH_LOGIN}}}
					{+START,IF,{$NOT,{$MOBILE}}}
						<form class="inline horiz_field_sep associated_link" title="{!LOGOUT}" method="post" action="{LOGOUT_URL*}" autocomplete="off"><input class="button_hyperlink" type="submit" value="{!LOGOUT}" /></form>
					{+END}
				{+END}

				<dl class="meta_details_list">
					{+START,IF,{$ADDON_INSTALLED,points}}
						<dt class="field_name"><abbr title="{!LIFETIME_POINTS,{$NUMBER_FORMAT*,{$AVAILABLE_POINTS}}}">{!POINTS}</abbr>:</dt> <dd><a{+START,IF_PASSED,NUM_POINTS_ADVANCE} title="{!GROUP_ADVANCE,{NUM_POINTS_ADVANCE*}}"{+END} href="{$PAGE_LINK*,site:points:member:{$MEMBER}}">{NUM_POINTS*}</a></dd>
					{+END}
					<dt class="field_name">{!COUNT_POSTS}:</dt> <dd>{NUM_POSTS*}</dd>
					<dt class="field_name">{$?,{$MOBILE},{!USERGROUP},{!PRIMARY_GROUP}}:</dt> <dd>{PRIMARY_GROUP*}</dd>
				</dl>
			</div>

			<div{+START,IF,{$NOT,{$MOBILE}}} style="min-height: {$MAX,100,{MAX_AVATAR_HEIGHT|}}px"{+END} class="cns_member_column cns_member_column_c">
				{+START,IF,{$ADDON_INSTALLED,search}}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,search}}
					<div class="box nested"><div class="box_inner">{+START,INCLUDE,MEMBER_BAR_SEARCH}{+END}</div></div>
				{+END}{+END}

				<div class="cns_member_column_last_visit">{!LAST_VISIT,{LAST_VISIT_DATE*}}
					<ul class="meta_details_list">
						<li>{!NEW_TOPICS,{NEW_TOPICS*}}</li>
						<li>{!NEW_POSTS,{NEW_POSTS*}}</li>
					</ul>
				</div>
			</div>

			<nav{+START,IF,{$NOT,{$MOBILE}}} style="min-height: {$MAX,100,{MAX_AVATAR_HEIGHT|}}px"{+END} class="cns_member_column cns_member_column_d">
				{$,<p class="cns_member_column_title">{!VIEW}:</p>}
				<ul class="actions_list">
					<!--<li><a href="{PRIVATE_TOPIC_URL*}">{!PRIVATE_TOPICS}{+START,IF_NON_EMPTY,{PT_EXTRA}} <span class="cns_member_column_pts">{PT_EXTRA}</span>{+END}</a></li>-->
					<li><a{+START,IF,{$NOT,{$MOBILE}}} onclick="return open_link_as_overlay(this);"{+END} href="{NEW_POSTS_URL*}">{!POSTS_SINCE}</a></li>
					<li><a{+START,IF,{$NOT,{$MOBILE}}} onclick="return open_link_as_overlay(this);"{+END} href="{UNREAD_TOPICS_URL*}">{!TOPICS_UNREAD}</a></li>
					<li><a{+START,IF,{$NOT,{$MOBILE}}} onclick="return open_link_as_overlay(this);"{+END} href="{RECENTLY_READ_URL*}">{!RECENTLY_READ}</a></li>
					<li><a{+START,IF,{$NOT,{$MOBILE}}} onclick="return open_link_as_overlay(this);"{+END} href="{INLINE_PERSONAL_POSTS_URL*}">{!INLINE_PERSONAL_POSTS}</a></li>
					<li><a{+START,IF,{$NOT,{$MOBILE}}} onclick="return open_link_as_overlay(this);"{+END} href="{UNANSWERED_TOPICS_URL*}">{!UNANSWERED_TOPICS}</a></li>
					<li><a{+START,IF,{$NOT,{$MOBILE}}} onclick="return open_link_as_overlay(this);"{+END} href="{INVOLVED_TOPICS_URL*}">{!INVOLVED_TOPICS}</a></li>
				</ul>
			</nav>
		</div>
	</div>
</section>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		{+START,IF,{$JS_ON}}
			handle_tray_cookie_setting('{!MEMBER|}');
		{+END}
	});
//]]></script>
