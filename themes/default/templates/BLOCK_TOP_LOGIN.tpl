{+START,IF,{$NOR,{$GET,login_screen},{$MATCH_KEY_MATCH,_WILD:login}}}
	<div data-tpl="blockTopLogin">
		<form title="{!_LOGIN}" action="{LOGIN_URL*}" method="post" class="form-inline top-login js-form-top-login" autocomplete="on">
			{$INSERT_SPAMMER_BLACKHOLE}

			{+START,IF,{$DESKTOP}}
				<div class="top-login-controls display-desktop">
					<div class="accessibility-hidden"><label for="s-login-username">{$LOGIN_LABEL}</label></div>
					<input maxlength="80" size="10" accesskey="l" type="text" placeholder="{!USERNAME}" id="s-login-username" name="login_username" class="form-control" />
					<div class="accessibility-hidden"><label for="s-password">{!PASSWORD}</label></div>
					<input maxlength="255" size="10" type="password" placeholder="{!PASSWORD}" name="password" id="s-password" class="form-control" />

					{+START,IF,{$CONFIG_OPTION,password_cookies}}
						<label class="accessibility-hidden" for="s-remember">{!REMEMBER_ME}</label>
						<input title="{!REMEMBER_ME}"{+START,IF,{$CONFIG_OPTION,remember_me_by_default}} checked="checked"{+END} class="{+START,IF,{$NOT,{$CONFIG_OPTION,remember_me_by_default}}}js-click-confirm-remember-me{+END}" type="checkbox" value="1" id="s-remember" name="remember" />
					{+END}

					<button class="btn btn-primary menu--site-meta--user-actions--login" type="submit">{+START,INCLUDE,ICON}NAME=menu/site_meta/user_actions/login{+END} {!_LOGIN}</button>
				</div>
			{+END}

			<ul class="horizontal-links with-icons bock-top-login-links">
				{+START,IF_NON_EMPTY,{JOIN_URL}}<li><a href="{JOIN_URL*}">{+START,INCLUDE,ICON}NAME=menu/site_meta/user_actions/join{+END}{!_JOIN}</a></li>{+END}
				<li><a data-open-as-overlay="{}" rel="nofollow" href="{FULL_LOGIN_URL*}" title="{!MORE}: {!_LOGIN}">{+START,INCLUDE,ICON}NAME=menu/site_meta/user_actions/login{+END} {+START,IF,{$DESKTOP}}<span class="inline-desktop">{!OPTIONS}</span>{+END}<span class="inline-mobile">{!_LOGIN}</span></a></li>
			</ul>
		</form>
	</div>
{+END}
