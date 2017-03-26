<section id="tray_{!MEMBER|}" data-view="ToggleableTray" data-tray-cookie="{!MEMBER|}" class="box cns_information_bar_outer">
	<h2 class="toggleable_tray_title js-tray-header">
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!_LOGIN}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{!_LOGIN}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,search}} / {!SEARCH}{+END}</a>
	</h2>

	<div class="toggleable_tray js-tray-content">
		<div class="cns_information_bar float_surrounder">
			<div class="cns_guest_column cns_guest_column_a">
				<form title="{!_LOGIN}" onsubmit="if ($cms.form.checkFieldForBlankness(this.elements['login_username'])) { $cms.ui.disableFormButtons(this); return true; } return false;" action="{LOGIN_URL*}" method="post" class="inline" autocomplete="on">
					{$INSERT_SPAMMER_BLACKHOLE}

					<div>
						<div class="accessibility_hidden"><label for="member_bar_login_username">{$LOGIN_LABEL}</label></div>
						<div class="accessibility_hidden"><label for="member_bar_s_password">{!PASSWORD}</label></div>
						<input size="15" type="text" placeholder="{!USERNAME}" id="member_bar_login_username" name="login_username" />
						<input size="15" type="password" placeholder="{!PASSWORD}" value="" name="password" id="member_bar_s_password" />
						{+START,IF,{$CONFIG_OPTION,password_cookies}}
							<label for="remember">{!REMEMBER_ME}:</label> <input {+START,IF,{$CONFIG_OPTION,remember_me_by_default}} checked="checked"{+END}{+START,IF,{$NOT,{$CONFIG_OPTION,remember_me_by_default}}} onclick="if (this.checked) { var t=this; $cms.ui.confirm('{!REMEMBER_ME_COOKIE;}',function(answer) { if (!answer) { t.checked=false; } }); }"{+END} type="checkbox" value="1" id="remember" name="remember" />
						{+END}
						<input class="button_screen_item menu__site_meta__user_actions__login" type="submit" value="{!_LOGIN}" />

						{+START,IF_EMPTY,{$FB_CONNECT_UID}}
							{+START,IF_NON_EMPTY,{$CONFIG_OPTION,facebook_appid}}{+START,IF,{$CONFIG_OPTION,facebook_allow_signups}}
								<div class="fb-login-button" data-scope="email{$,Asking for this stuff is now a big hassle as it needs a screencast(s) making: user_birthday,user_about_me,user_hometown,user_location,user_website}{+START,IF,{$CONFIG_OPTION,facebook_auto_syndicate}},publish_actions,publish_pages{+END}"></div>
							{+END}{+END}
						{+END}
						<ul class="horizontal_links associated_links_block_group horiz_field_sep">
							<li><a href="{JOIN_URL*}">{!_JOIN}</a></li>
							<li><a data-open-as-overlay="1" rel="nofollow" href="{FULL_LOGIN_URL*}" title="{!MORE}: {!_LOGIN}">{!MORE}</a></li>
						</ul>
					</div>
				</form>
			</div>
			{+START,IF,{$ADDON_INSTALLED,search}}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,search}}
				<div class="cns_guest_column cns_guest_column_c">
					{+START,INCLUDE,MEMBER_BAR_SEARCH}{+END}
				</div>
			{+END}{+END}

			<nav class="cns_guest_column cns_member_column_d">
				{$,<p class="cns_member_column_title">{!VIEW}:</p>}
				<ul class="actions_list">
					<li><a data-open-as-overlay="1" href="{NEW_POSTS_URL*}">{!POSTS_SINCE}</a></li>
					<li><a data-open-as-overlay="1" href="{UNANSWERED_TOPICS_URL*}">{!UNANSWERED_TOPICS}</a></li>
				</ul>
			</nav>
		</div>
	</div>
</section>

