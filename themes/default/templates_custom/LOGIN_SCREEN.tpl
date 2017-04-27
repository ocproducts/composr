<div data-require-javascript="openid" data-tpl="loginScreen">
{TITLE}

{$SET,login_screen,1}

<div class="login_page">
	{+START,IF_NON_EMPTY,{$CONFIG_OPTION,facebook_appid}}{+START,IF,{$CONFIG_OPTION,facebook_allow_signups}}
		{+START,IF_EMPTY,{$FB_CONNECT_UID}}
			<h2>{!facebook:LOGIN_FACEBOOK_HEADER}</h2>

			<p>{!facebook:LOGIN_USING_FACEBOOK}</p>

			<div class="fb-login-button" data-show-faces="true" data-width="200" data-max-rows="1" data-scope="email{$,Asking for this stuff is now a big hassle as it needs a screencast(s) making: user_birthday,user_about_me,user_hometown,user_location,user_website}{+START,IF,{$CONFIG_OPTION,facebook_auto_syndicate}},publish_actions,publish_pages{+END}"></div>
		{+END}

		<h2>{!facebook:LOGIN_NATIVE_HEADER,{$SITE_NAME*}}</h2>
	{+END}{+END}

	<div class="box box___login_screen"><div class="box_inner">
		{!LOGIN_TEXT,<a href="{JOIN_URL*}"><strong>{!JOIN_HERE}</strong></a>}
	</div></div>

	<form title="{!_LOGIN}" class="js-submit-check-username-for-blankness" action="{LOGIN_URL*}" method="post" autocomplete="on">
		<div>
			{$INSERT_SPAMMER_BLACKHOLE}

			{PASSION}

			<div class="float_surrounder">
				{+START,IF,{$MOBILE}}
					<div class="login_page_form">
						<p class="constrain_field">
							<label for="login_username">{$LOGIN_LABEL}</label>
							<input maxlength="80" type="text" value="{USERNAME*}" id="login_username" name="login_username" size="15" />
						</p>

						<p class="constrain_field">
							<label for="password">{!PASSWORD}</label>
							<input maxlength="255" type="password" id="password" name="password" size="15" />
						</p>
					</div>
				{+END}

				{+START,IF,{$NOT,{$MOBILE}}}
					<table class="map_table autosized_table login_page_form">
						<tbody>
							<tr>
								<th class="de_th"><label for="login_username">{$LOGIN_LABEL}</label>:</th>
								<td>
									<input maxlength="80" type="text" value="{USERNAME*}" id="login_username" name="login_username" size="25" />
								</td>
							</tr>
							<tr>
								<th class="de_th"><label for="password">{!PASSWORD}</label>:</th>
								<td>
									<input maxlength="255" type="password" id="password" name="password" size="25" />
								</td>
							</tr>
						</tbody>
					</table>
				{+END}

				{+START,IF,{$CONFIG_OPTION,password_cookies}}
					<div class="login_page_options">
						<p>
							<label for="remember">
							  <input class="{+START,IF,{$NOT,{$CONFIG_OPTION,remember_me_by_default}}}js-click-confirm-remember-me{+END}" id="remember" type="checkbox" value="1" name="remember"{+START,IF,{$CONFIG_OPTION,remember_me_by_default}} checked="checked"{+END} />
							  <span class="field_name">{!REMEMBER_ME}</span>
							</label>
							<span class="associated_details">{!REMEMBER_ME_TEXT}</span>
						</p>

						{+START,IF,{$CONFIG_OPTION,is_on_invisibility}}
							<p>
								<label for="login_invisible">
									<input id="login_invisible" type="checkbox" value="1" name="login_invisible" />
									<span class="field_name">{!INVISIBLE}</span>
								</label>
								<span class="associated_details">{!INVISIBLE_TEXT}</span>
							</p>
						{+END}
					</div>
				{+END}
			</div>

			<p class="proceed_button">
				<input class="button_screen menu__site_meta__user_actions__login" type="submit" value="{!_LOGIN}" />
			</p>
		</div>
	</form>

	{+START,IF_NON_EMPTY,{EXTRA}}
		<p class="login_note">
			{EXTRA}
		</p>
	{+END}

	{+START,IF_NON_EMPTY,{$BLOCK,block=openid,failsafe=1}}
		<div class="openid_wrap">
			<h2>Log in using OpenID</h2>

			{$BLOCK,block=openid}
		</div>
	{+END}
</div>
</div>