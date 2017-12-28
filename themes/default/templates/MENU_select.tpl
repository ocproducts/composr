{$REQUIRE_CSS,menu__select}
{$REQUIRE_JAVASCRIPT,core_menus}
{$SET,menu_id,r_{MENU|}}
<div class="menu_type__select" data-view="SelectMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
	<form title="{!MENU} ({!FORM_AUTO_SUBMITS})" method="get" action="#!" autocomplete="off">
		<div>
			<div class="accessibility_hidden"><label for="menu_select_{MENU|}">{!MENU}</label></div>
			<select id="menu_select_{MENU|}" name="menu_select_{MENU|}" class="wide-field js-change-redirect-to-value">
				{CONTENT}
			</select>
		</div>
	</form>
</div>
