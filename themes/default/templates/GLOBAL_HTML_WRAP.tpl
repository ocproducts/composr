<!DOCTYPE html>

<!--
Powered by {$BRAND_NAME*} version {$VERSION_NUMBER*}, (c) ocProducts Ltd
{$BRAND_BASE_URL*}
-->

{$SET,page_link_privacy,{$PAGE_LINK,:privacy}}

{$,We deploy as HTML5 but code and conform strictly to XHTML5}
<html lang="{$LCASE*,{$LANG}}" dir="{!dir}" data-view="Global" data-view-params="{+START,PARAMS_JSON,page_link_privacy}{_*}{+END}" class="has-sticky-navbar {$?,{$MATCH_KEY_MATCH,:home},has-hero-carousel,has-no-hero-carousel} is-not-scrolled">
<head>
	{+START,INCLUDE,HTML_HEAD}{+END}
</head>

{$,You can use main-website-inner to help you create fixed width designs; never put fixed-width stuff directly on ".website-body" or "body" because it will affects things like the preview or banner frames or popups/overlays}
<body class="website-body zone-running-{$REPLACE*,_,-,{$ZONE}} page-running-{$REPLACE*,_,-,{$PAGE}}" id="main-website" itemscope="itemscope" itemtype="http://schema.org/WebPage" data-tpl="globalHtmlWrap">
	<div id="main-website-inner">
		{+START,IF,{$SHOW_HEADER}}
		{$,Add CSS class .with-white-navbar for a white navbar, .with-seed-navbar for seed-colored navbar}
		<header itemscope="itemscope" itemtype="http://schema.org/WPHeader" class="with-white-navbar with-sticky-navbar" data-sticky-navbar="{}">
			{$,This allows screen-reader users (e.g. blind users) to jump past the panels etc to the main content}
			<a accesskey="s" class="accessibility-hidden" href="#maincontent">{!SKIP_NAVIGATION}</a>

			{$,Main menu}
			<div class="global-navigation">
				<div class="global-navigation-inner container">
					<div class="row">
						<div class="col-auto col-logo">
							{$,The main logo}
							<h1 class="logo-outer">
								<a target="_self" href="{$PAGE_LINK*,:}" rel="home" title="{!HOME}" class="logo">
									{$SITE_NAME*}
									<!--<img class="logo" src="{$LOGO_URL*}" alt="{$SITE_NAME*}" />-->
								</a>
							</h1>
						</div>
						<div class="col-auto col-navigation">
							{$BLOCK,block=menu,param={$CONFIG_OPTION,header_menu_call_string},type=dropdown}

							{$,Login form for guests}
							{+START,IF,{$IS_GUEST}}{+START,IF,{$CONFIG_OPTION,block_top_login}}
							<div class="top-form top-login">
								{$BLOCK,block=top_login}
							</div>
							{+END}{+END}

							{+START,IF,{$NOT,{$IS_GUEST}}}{+START,IF,{$OR,{$CONFIG_OPTION,block_top_notifications},{$CONFIG_OPTION,block_top_personal_stats}}}
							<div class="top-buttons">
								{+START,IF,{$CONFIG_OPTION,block_top_notifications}}{$BLOCK,block=top_notifications}{+END}

								{+START,IF,{$CONFIG_OPTION,block_top_personal_stats}}{$BLOCK,block=top_personal_stats}{+END}

								{$,Search box for logged in users [could show to guests, except space is lacking]}
								{+START,IF,{$AND,{$ADDON_INSTALLED,search},{$DESKTOP},{$NOT,{$IS_GUEST}}}}{+START,IF,{$CONFIG_OPTION,block_top_search,1}}
								{$BLOCK,block=top_search,block_id=desktop,failsafe=1,limit_to={$?,{$MATCH_KEY_MATCH,forum:_WILD},cns_posts,all_defaults}}
								{+END}{+END}
							</div>
							{+END}{+END}
						</div>
					</div>
				</div>
			</div>
		</header>
		{+END}

		{+START,IF,{$MATCH_KEY_MATCH,:home}}
			<div id="hero-carousel" class="cms-carousel slide cms-carousel-home-hero has-multiple-items" data-ride="carousel">
				<!--<ol class="cms-carousel-indicators">-->
					<!--<li data-target="#hero-carousel" data-slide-to="0" class="active"></li>-->
					<!--<li data-target="#hero-carousel" data-slide-to="1"></li>-->
					<!--<li data-target="#hero-carousel" data-slide-to="2"></li>-->
				<!--</ol>-->
				<a href="#!" class="cms-carousel-scroll-button">
					<div class="cms-carousel-scroll-button-icon">
						{+START,INCLUDE,ICON}NAME=results/sortablefield_desc{+END}
					</div>
					<div class="cms-carousel-scroll-button-caption">
						Scroll Down
					</div>
				</a>
				<div class="cms-carousel-inner">
					<div class="cms-carousel-item active">
						<h1 style="text-align: center; margin-top: 100px; color: white;">Slide 1</h1>
					</div>
					<div class="cms-carousel-item">
						<h1 style="text-align: center; margin-top: 100px; color: white;">Slide 2</h1>
					</div>
					<div class="cms-carousel-item">
						<h1 style="text-align: center; margin-top: 100px; color: white;">Slide 3</h1>
					</div>
				</div>
				<a class="cms-carousel-control-prev" href="#hero-carousel" role="button" data-slide="prev">
					<span class="cms-carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="sr-only">Previous</span>
				</a>
				<a class="cms-carousel-control-next" href="#hero-carousel" role="button" data-slide="next">
					<span class="cms-carousel-control-next-icon" aria-hidden="true"></span>
					<span class="sr-only">Next</span>
				</a>
				<div class="cms-carousel-progress-bar">
					<div class="cms-carousel-progress-bar-fill"></div>
				</div>
			</div>
		{+END}

		<div class="container">
			{$,By default the top panel contains the admin menu, community menu, member bar, etc}
			{+START,IF_NON_EMPTY,{$TRIM,{$LOAD_PANEL,top}}}
				<div id="panel-top">
					{$LOAD_PANEL,top}
				</div>
			{+END}
	
			{$,Composr may show little messages for you as it runs relating to what you are doing or the state the site is in}
			<div class="global-messages" id="global-messages">
				{$MESSAGES_TOP}
			</div>
	
			{$,The main panels and content; .clearfix contains the layout into a rendering box so that the footer etc can sit underneath}
			<div class="global-middle-outer">
				{$SET,has_left_panel,{$IS_NON_EMPTY,{$TRIM,{$LOAD_PANEL,left}}}}
				{$SET,has_right_panel,{$IS_NON_EMPTY,{$TRIM,{$LOAD_PANEL,right}}}}
	
				<article class="global-middle {$?,{$GET,has_left_panel},has-left-panel,has-no-left-panel} {$?,{$GET,has_right_panel},has-right-panel,has-no-right-panel}" role="main">
					{$,Breadcrumbs}
					{+START,IF,{$IN_STR,{$BREADCRUMBS},<a }}{+START,IF,{$SHOW_HEADER}}
						<nav class="global-breadcrumbs breadcrumbs" itemprop="breadcrumb" id="global-breadcrumbs">
							{+START,INCLUDE,ICON}
								NAME=breadcrumbs
								ICON_TITLE={!YOU_ARE_HERE}
								ICON_DESCRIPTION={!YOU_ARE_HERE}
								ICON_SIZE=24
								ICON_CLASS=breadcrumbs-img
							{+END}
							{$BREADCRUMBS}
						</nav>
					{+END}{+END}
	
					{$,Associated with the SKIP_NAVIGATION link defined further up}
					<a id="maincontent"></a>
	
					{$,The main site, whatever 'page' is being loaded}
					{MIDDLE}
				</article>
	
				{+START,IF,{$GET,has_left_panel}}
					<div id="panel-left" class="global-side-panel{+START,IF,{$GET,has_right_panel}} with-both-panels{+END}" role="complementary" itemscope="itemscope" itemtype="http://schema.org/WPSideBar">
						<div class="stuck-nav" data-stuck-nav>{$LOAD_PANEL,left}</div>
					</div>
				{+END}
	
				{+START,IF,{$GET,has_right_panel}}
					<div id="panel-right" class="global-side-panel{+START,IF,{$GET,has_left_panel}} with-both-panels{+END}" role="complementary" itemscope="itemscope" itemtype="http://schema.org/WPSideBar">
						<div class="stuck-nav" data-stuck-nav>{$LOAD_PANEL,right}</div>
					</div>
				{+END}
			</div>
	
			{+START,IF_NON_EMPTY,{$TRIM,{$LOAD_PANEL,bottom}}}
				<div id="panel-bottom" role="complementary">
					{$LOAD_PANEL,bottom}
				</div>
			{+END}
	
			{+START,IF_NON_EMPTY,{$MESSAGES_BOTTOM}}
				<div class="global-messages">
					{$MESSAGES_BOTTOM}
				</div>
			{+END}
	
			{+START,IF,{$SHOW_FOOTER}}
				{+START,IF,{$EQ,{$CONFIG_OPTION,sitewide_im,1},1}}{$CHAT_IM}{+END}
			{+END}
	
			{$,Late messages happen if something went wrong during outputting everything (i.e. too late in the process to show the error in the normal place)}
			{+START,IF_NON_EMPTY,{$LATE_MESSAGES}}
				<div class="global-messages" id="global-messages-2">
					{$LATE_MESSAGES}
				</div>
			{+END}
		</div>

		<noscript>
			{!JAVASCRIPT_REQUIRED}
		</noscript>

		{$,This is the main site footer}
		{+START,IF,{$SHOW_FOOTER}}
			<footer class="clearfix" itemscope="itemscope" itemtype="http://schema.org/WPFooter" role="contentinfo">
				<div class="footer-inner container">
					<div class="global-footer-left block-desktop">
						{+START,SET,FOOTER_BUTTONS}
						{+START,IF,{$CONFIG_OPTION,bottom_show_top_button}}
						<li>
							<a rel="back_to_top" accesskey="g" href="#" title="{!BACK_TO_TOP}">
								{+START,INCLUDE,ICON}
								NAME=tool_buttons/top
								SIZE=24
								{+END}
							</a>
						</li>
						{+END}
						{+START,IF,{$ADDON_INSTALLED,realtime_rain}}{+START,IF,{$CONFIG_OPTION,bottom_show_realtime_rain_button,1}}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_realtime_rain}}{+START,IF,{$NEQ,{$ZONE}:{$PAGE},adminzone:admin_realtime_rain}}
						<li>
							<a id="realtime-rain-button" data-btn-load-realtime-rain="{}" title="{!realtime_rain:REALTIME_RAIN}" href="{$PAGE_LINK*,adminzone:admin_realtime_rain}">
								{+START,INCLUDE,ICON}
								NAME=tool_buttons/realtime_rain_on
								ICON_ID=realtime-rain-img
								ICON_SIZE=24
								{+END}
							</a>
						</li>
						{+END}{+END}{+END}{+END}
						{+START,IF,{$HAS_ZONE_ACCESS,adminzone}}
						{+START,IF,{$ADDON_INSTALLED,commandr}}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_commandr}}{+START,IF,{$CONFIG_OPTION,bottom_show_commandr_button,1}}{+START,IF,{$NEQ,{$ZONE}:{$PAGE},adminzone:admin_commandr}}
						<li>
							<a id="commandr-button" accesskey="o"{+START,IF,{$DESKTOP}} data-btn-load-commandr="{}" {+END} href="{$PAGE_LINK*,adminzone:admin_commandr}">
								{+START,INCLUDE,ICON}
								NAME=tool_buttons/commandr_on
								ICON_CLASS=commandr-img
								ICON_TITLE={!commandr:COMMANDR_DESCRIPTIVE_TITLE}
								ICON_DESCRIPTION={!commandr:COMMANDR_DESCRIPTIVE_TITLE}
								ICON_SIZE=24
								{+END}
							</a>
						</li>
						{+END}{+END}{+END}{+END}
						<li>
							<a href="{$PAGE_LINK*,adminzone:,,,,keep_theme}">
								{+START,INCLUDE,ICON}
								NAME=menu/adminzone/adminzone
								ICON_TITLE={!ADMIN_ZONE}
								ICON_SIZE=24
								{+END}
							</a>
						</li>
						{+START,IF,{$DESKTOP}}{+START,IF,{$EQ,{$BRAND_NAME},Composr}}
						<li>
							<a id="software-chat-button" accesskey="-" href="#!" class="js-global-click-load-software-chat">
								{+START,INCLUDE,ICON}
								NAME=tool_buttons/software_chat
								ICON_CLASS=software-chat-img
								ICON_TITLE={!SOFTWARE_CHAT}
								ICON_DESCRIPTION={!SOFTWARE_CHAT}
								ICON_SIZE=24
								{+END}
							</a>
						</li>
						{+END}{+END}
						{+END}
						{+END}
						{+START,IF_NON_EMPTY,{$TRIM,{$GET,FOOTER_BUTTONS}}}{+START,IF,{$DESKTOP}}
						<ul class="horizontal-buttons">
							{$GET,FOOTER_BUTTONS}
						</ul>
						{+END}{+END}

						{+START,IF,{$HAS_SU}}
						<form title="{!SU} {!LINK_NEW_WINDOW}" class="inline su-form" method="get" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}" target="_blank" autocomplete="off">
							{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1},keep_su}

							<div class="inline">
								<div class="accessibility-hidden"><label for="su">{!SU}</label></div>
								<div class="input-group">
									<input title="{!SU_2}" class="form-control form-control-sm js-global-input-su-keypress-enter-submit-form" accesskey="w" size="10" type="text"{+START,IF_NON_EMPTY,{$_GET,keep_su}} placeholder="{$USERNAME*}"{+END} value="{+START,IF_NON_EMPTY,{$_GET,keep_su}}{$USERNAME*}{+END}" id="su" name="keep_su" />
									<div class="input-group-append">
										<button data-disable-on-click="1" class="btn btn-primary btn-sm menu--site-meta--user-actions--login" type="submit">{+START,INCLUDE,ICON}NAME=menu/site_meta/user_actions/login{+END} {!SU}</button>
									</div>
								</div>
							</div>
						</form>
						{+END}

						{+START,IF,{$DESKTOP}}{+START,IF_NON_EMPTY,{$STAFF_ACTIONS}}{+START,IF,{$CONFIG_OPTION,show_staff_page_actions}}
						<form title="{!SCREEN_DEV_TOOLS} {!LINK_NEW_WINDOW}" class="inline special-page-type-form js-global-submit-staff-actions-select" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}" method="get" target="_blank" autocomplete="off">
							{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1,0,cache_blocks=0,cache_comcode_pages=0,keep_minify=0,special_page_type=<null>,keep_template_magic_markers=<null>}}

							<div class="inline">
								<p class="accessibility-hidden"><label for="special-page-type">{!SCREEN_DEV_TOOLS}</label></p>
								<div class="input-group">
									<select id="special-page-type" name="special_page_type" class="form-control form-control-sm">{$STAFF_ACTIONS}</select>
									<div class="input-group-append">
										<button class="btn btn-primary btn-sm buttons--proceed" type="submit">{+START,INCLUDE,ICON}NAME=buttons/proceed{+END} {!PROCEED_SHORT}</button>
									</div>
								</div>
							</div>
						</form>
						{+END}{+END}{+END}
					</div>

					<div class="global-footer-right">
						<nav class="global-minilinks">
							<ul class="footer-links">
								{+START,IF,{$CONFIG_OPTION,bottom_show_sitemap_button}}
								<li><a accesskey="3" rel="site_map" href="{$PAGE_LINK*,_SEARCH:sitemap}">{!SITEMAP}</a></li>
								{+END}
								{+START,IF,{$CONFIG_OPTION,bottom_show_rules_link}}
								<li><a data-open-as-overlay="{}" rel="site_rules" accesskey="7" href="{$PAGE_LINK*,:rules}">{!RULES}</a></li>
								{+END}
								{+START,IF,{$CONFIG_OPTION,bottom_show_privacy_link}}
								<li><a data-open-as-overlay="{}" rel="site_privacy" accesskey="8" href="{$PAGE_LINK*,_SEARCH:privacy}">{!PRIVACY}</a></li>
								{+END}
								{+START,IF,{$CONFIG_OPTION,bottom_show_feedback_link}}
								<li><a data-open-as-overlay="{}" rel="site_contact" accesskey="9" href="{$PAGE_LINK*,_SEARCH:feedback:redirect={$SELF_URL&,1}}">{!_FEEDBACK}</a></li>
								{+END}
								{+START,IF,{$NOR,{$IS_HTTPAUTH_LOGIN},{$IS_GUEST}}}
								<li><form title="{!LOGOUT}" class="inline" method="post" action="{$PAGE_LINK*,_SELF:login:logout}" autocomplete="off"><button class="button-hyperlink" type="submit" title="{!_LOGOUT,{$USERNAME*}}">{!LOGOUT}</button></form></li>
								{+END}
								{+START,IF,{$OR,{$IS_HTTPAUTH_LOGIN},{$IS_GUEST}}}
								<li><a data-open-as-overlay="{}" href="{$PAGE_LINK*,_SELF:login:{$?,{$NOR,{$GET,login_screen},{$?,{$NOR,{$GET,login_screen},{$_POSTED},{$EQ,{$PAGE},login,join}},redirect={$SELF_URL&*,1}}}}}">{!_LOGIN}</a></li>
								{+END}
								{+START,IF,{$THEME_OPTION,mobile_support}}
								{+START,IF,{$MOBILE}}
								<li><a href="{$SELF_URL*,1,0,0,keep_mobile=0}">{!NONMOBILE_VERSION}</a>
									{+END}
									{+START,IF,{$DESKTOP}}
								<li><a href="{$SELF_URL*,1,0,0,keep_mobile=1}">{!MOBILE_VERSION}</a></li>
								{+END}
								{+END}
								{+START,IF,{$HAS_ZONE_ACCESS,adminzone}}
								{+START,IF,{$ADDON_INSTALLED,commandr}}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_commandr}}{+START,IF,{$CONFIG_OPTION,bottom_show_commandr_button,1}}{+START,IF,{$NEQ,{$ZONE}:{$PAGE},adminzone:admin_commandr}}
								<li class="inlineblock-mobile"><a accesskey="o" href="{$PAGE_LINK*,adminzone:admin_commandr}">{!commandr:COMMANDR}</a></li>
								{+END}{+END}{+END}{+END}
								<li class="inlineblock-mobile"><a href="{$PAGE_LINK*,adminzone:}">{!ADMIN_ZONE}</a></li>
								{+END}
								{+START,IF,{$CONFIG_OPTION,bottom_show_top_button}}
								<li class="inlineblock-mobile"><a rel="back_to_top" accesskey="g" href="#">{!_BACK_TO_TOP}</a></li>
								{+END}
								{+START,IF_NON_EMPTY,{$HONEYPOT_LINK}}
								<li class="accessibility-hidden">{$HONEYPOT_LINK}</li>
								{+END}
								<li class="accessibility-hidden"><a accesskey="1" href="{$PAGE_LINK*,:}">{$SITE_NAME*}</a></li>
								<li class="accessibility-hidden"><a accesskey="0" href="{$PAGE_LINK*,:keymap}">{!KEYBOARD_MAP}</a></li>
							</ul>
						</nav>

						<div class="global-copyright">
							{$,Uncomment to show user's time {$DATE} {$TIME}}

							{$COPYRIGHT`}
						</div>
					</div>
				</div>
			</footer>
		{+END}

		{$EXTRA_FOOT}

		{$JS_TEMPCODE}
	</div>
</body>
</html>
