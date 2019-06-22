{$REQUIRE_JAVASCRIPT,facebook_support}
{+START,IF,{$NOR,{$GET,login_screen},{$MATCH_KEY_MATCH,_WILD:login}}}
	<section class="box box---block-side-personal-stats-no" data-tpl="blockSidePersonalStatsNo"><div class="box-inner">
		{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE}</h3>{+END}

		<form title="{!_LOGIN}" class="js-submit-check-username-for-blankness" action="{LOGIN_URL*}" method="post" autocomplete="on">
			{$INSERT_SPAMMER_BLACKHOLE}

			<input type="hidden" name="_active_login" value="1" />

			<div>
				<div>
					<div class="accessibility-hidden"><label for="ps-login-username">{$LOGIN_LABEL}</label></div>
					<input maxlength="80" class="form-control form-control-wide login-block-username" type="text" placeholder="{!USERNAME}" id="ps-login-username" name="username" autocomplete="username" />
					<div class="accessibility-hidden"><label for="ps-password">{!PASSWORD}</label></div>
					<input maxlength="255" class="form-control form-control-wide" type="password" placeholder="{!PASSWORD}" name="password" autocomplete="current-password" id="ps-password" />
				</div>

				{+START,IF,{$CONFIG_OPTION,password_cookies}}
					<div class="login-block-cookies">
						<div class="clearfix">
							<label for="ps-remember">{!REMEMBER_ME}</label>
							<input class="{+START,IF,{$NOT,{$CONFIG_OPTION,remember_me_by_default}}} js-click-confirm-remember-me{+END}"{+START,IF,{$CONFIG_OPTION,remember_me_by_default}} checked="checked"{+END} type="checkbox" value="1" id="ps-remember" name="remember" />
						</div>
						{+START,IF,{$CONFIG_OPTION,is_on_invisibility}}
							<div class="clearfix">
								<label for="login_invisible">{!INVISIBLE}</label>
								<input type="checkbox" value="1" id="login_invisible" name="login_invisible" />
							</div>
						{+END}
					</div>
				{+END}

				<p class="proceed-button">
					<button class="btn btn-primary btn-scri menu--site-meta--user-actions--login" type="submit">{+START,INCLUDE,ICON}NAME=menu/site_meta/user_actions/login{+END} {!_LOGIN}</button>
				</p>
			</div>
		</form>

		<ul class="horizontal-links associated-links-block-group force-margin">
			{+START,IF_NON_EMPTY,{JOIN_URL}}<li><a href="{JOIN_URL*}">{!_JOIN}</a></li>{+END}
			<li><a data-open-as-overlay="{}" rel="nofollow" href="{FULL_LOGIN_URL*}" title="{!MORE}: {!_LOGIN}">{!MORE}</a></li>
		</ul>

		{+START,IF_NON_EMPTY,{$CONFIG_OPTION,facebook_appid}}{+START,IF,{$CONFIG_OPTION,facebook_allow_signups}}
			{+START,IF_EMPTY,{$FB_CONNECT_UID}}
				<div style="margin-top: 0.4em; text-align: center"><div class="fb-login-button" data-scope="email{$,Asking for this stuff is now a big hassle as it needs a screencast(s) making: user_birthday,user_about_me,user_hometown,user_location,user_website}{+START,IF,{$CONFIG_OPTION,facebook_auto_syndicate}},publish_actions,publish_pages{+END}"></div></div>
			{+END}
		{+END}{+END}
	</div></section>
{+END}
