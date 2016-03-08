<section class="box box___block_side_personal_stats"><div class="box_inner">
	<h3>{$DISPLAYED_USERNAME*,{USERNAME}}</h3>

	{+START,IF_NON_EMPTY,{AVATAR_URL}}
		<div class="personal_stats_avatar"><img src="{AVATAR_URL*}" title="{!AVATAR}" alt="{!AVATAR}" /></div>
	{+END}

	{+START,IF_NON_EMPTY,{DETAILS}}
		<ul class="compact_list">
			{DETAILS}
		</ul>
	{+END}

	{+START,IF_NON_EMPTY,{LINKS}}
		<ul class="associated_links_block_group">
			{LINKS}
		</ul>
	{+END}

	{+START,IF,{$CNS}}{+START,IF,{$NEQ,{$CPF_VALUE,m_password_compat_scheme},facebook}}
		{+START,IF_NON_EMPTY,{$CONFIG_OPTION,facebook_appid}}{+START,IF,{$CONFIG_OPTION,facebook_allow_signups}}
			<div class="fb-login-button" data-scope="email,user_birthday,user_about_me,user_hometown,user_location,user_website{+START,IF,{$CONFIG_OPTION,facebook_auto_syndicate}},publish_actions,publish_pages{+END}"></div>
		{+END}{+END}
	{+END}{+END}
</div></section>
