{$SET,login_screen,1}

{$REQUIRE_CSS,messages}

<div class="closed-site-special-message">
	<div class="closed-site-special-message-inner">
		<div class="box box---closed-site"><div class="box-inner">
			<h2>{$SITE_NAME*}</h2>

			<p>
				{CLOSED}
			</p>
			{+START,IF,{$IS_GUEST}}
				<p>
					{+START,IF_NON_EMPTY,{JOIN_URL}}
						{$,Re-enable if you want to allow people to easily join when the site is closed (or just give them the URL) <a class="btn btn-primary btn-scr menu--site-meta--user-actions--join" href="\{JOIN_URL*\}"><span>{+START,INCLUDE,ICON}NAME=menu/site_meta/user_actions/join{+END} \{!JOIN\}</span></a>}
					{+END}
					<a class="btn btn-primary btn-scr menu--site-meta--user-actions--login" data-open-as-overlay="{}" rel="nofollow" href="{LOGIN_URL*}">{+START,INCLUDE,ICON}NAME=menu/site_meta/user_actions/login{+END} <span>{!_LOGIN}</span></a>
				</p>
			{+END}
		</div></div>
	</div>
</div>
