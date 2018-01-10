{+START,IF,{$NOR,{$GET,login_screen},{$MATCH_KEY_MATCH,_WILD:login}}}
	<div data-tpl="blockTopLogin" class="inline">
		<form title="{!_LOGIN}" action="{LOGIN_URL*}" method="post" class="inline top_login js-form-top-login" autocomplete="on">
			{$INSERT_SPAMMER_BLACKHOLE}

			{+START,IF,{$DESKTOP}}
				<div class="inline-desktop">
					<div class="accessibility-hidden"><label for="s_login_username">{$LOGIN_LABEL}</label></div>
					<input maxlength="80" size="10" accesskey="l" type="text" placeholder="{!USERNAME}" id="s_login_username" name="login_username" />
					<div class="accessibility-hidden"><label for="s_password">{!PASSWORD}</label></div>
					<input maxlength="255" size="10" type="password" placeholder="{!PASSWORD}" name="password" id="s_password" />

					{+START,IF,{$CONFIG_OPTION,password_cookies}}
						<label class="accessibility-hidden" for="s_remember">{!REMEMBER_ME}</label>
						<input title="{!REMEMBER_ME}"{+START,IF,{$CONFIG_OPTION,remember_me_by_default}} checked="checked"{+END} class="{+START,IF,{$NOT,{$CONFIG_OPTION,remember_me_by_default}}}js-click-confirm-remember-me{+END}" type="checkbox" value="1" id="s_remember" name="remember" />
					{+END}

					<input class="button_screen_item menu__site_meta__user_actions__login" type="submit" value="{!_LOGIN}" />
				</div>
			{+END}

			<ul class="horizontal-links">
				{+START,IF_NON_EMPTY,{JOIN_URL}}<li><img alt="" src="{$IMG*,icons/24x24/menu/site_meta/user_actions/join}" srcset="{$IMG*,icons/48x48/menu/site_meta/user_actions/join} 2x" /> <a href="{JOIN_URL*}">{!_JOIN}</a></li>{+END}
				<li><img alt="" src="{$IMG*,icons/24x24/menu/site_meta/user_actions/login}" srcset="{$IMG*,icons/48x48/menu/site_meta/user_actions/login} 2x" /> <a data-open-as-overlay="{}" rel="nofollow" href="{FULL_LOGIN_URL*}" title="{!MORE}: {!_LOGIN}">{+START,IF,{$DESKTOP}}<span class="inline-desktop">{!OPTIONS}</span>{+END}<span class="inline-mobile">{!_LOGIN}</span></a></li>
			</ul>
		</form>
	</div>
{+END}
