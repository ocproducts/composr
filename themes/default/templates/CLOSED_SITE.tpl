{$SET,login_screen,1}

{$REQUIRE_CSS,messages}

<div class="closed_site_special_message">
	<div class="closed_site_special_message_inner">
		<div class="box box___closed_site"><div class="box_inner">
			<h2>{$SITE_NAME*}</h2>

			<p>
				{CLOSED}
			</p>
			{+START,IF,{$IS_GUEST}}
				<p>
					{+START,IF_NON_EMPTY,{JOIN_URL}}
						{$,Re-enable if you want to allow people to easily join when the site is closed (or just give them the URL) <a class="button_screen menu__site_meta__user_actions__join" href="\{JOIN_URL*\}"><span>\{!JOIN\}</span></a>}
					{+END}
					<a class="button_screen menu__site_meta__user_actions__login" onclick="return open_link_as_overlay(this);" rel="nofollow" href="{LOGIN_URL*}"><span>{!_LOGIN}</span></a>
				</p>
			{+END}
		</div></div>
	</div>
</div>

