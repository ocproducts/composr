{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,menu_popup}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__dropdown">
		<ul onmouseout="return deset_active_menu()" class="nl" id="r_{MENU|*}_d">
			{CONTENT}

			{$SET,RAND,{$RAND}}
			{$SET,HAS_CHILDREN,{$HAS_ACTUAL_PAGE_ACCESS,admin,adminzone}}
			<li class="non_current last toplevel"{+START,IF,{$GET,HAS_CHILDREN}}{+START,IF,{$NOT,{$MOBILE}}} onmousemove="window.menu_hold_time=3000; if (!this.timer) this.timer=window.setTimeout(function() { var ret=pop_up_menu('{MENU|;*}_dexpand_{$GET;*,RAND}','below','{MENU|;*}_d',event,true); try { document.getElementById('search_content').focus(); } catch (e) {} return ret; } , 200);" onmouseout="if (this.timer) { window.clearTimeout(this.timer); this.timer=null; }"{+END}{+END}>
				<a href="{$TUTORIAL_URL*,tutorials}" onclick="cancel_bubbling(event);{+START,IF,{$GET,HAS_CHILDREN}} deset_active_menu();{+END}" class="toplevel_link last"{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin,adminzone}} onfocus="return pop_up_menu('{MENU|;*}_dexpand_{$GET;*,RAND}','below','{MENU|;*}_d',event,true);"{+END} title="{!menus:MM_TOOLTIP_DOCS}"><img alt="" src="{$IMG*,icons/32x32/menu/adminzone/help}" srcset="{$IMG*,icons/64x64/menu/adminzone/help} 2x" /> <span>{!HELP}</span></a>
				{+START,IF,{$GET,HAS_CHILDREN}}
					<div aria-haspopup="true" onmouseover="if (active_menu==null) return set_active_menu(this.id,'{MENU|;*}_d'); else return false;" onmouseout="return deset_active_menu();" class="nlevel menu_help_section" id="{MENU|*}_dexpand_{$GET*,RAND}" style="display: none">
						{+START,INCLUDE,ADMIN_ZONE_SEARCH}{+END}
					</div>
				{+END}
			</li>
		</ul>
	</nav>

	{+START,IF_PASSED_AND_TRUE,JAVASCRIPT_HIGHLIGHTING}
		<script>// <![CDATA[
			menu_active_selection('r_{MENU|}_d');
		//]]></script>
	{+END}
{+END}
