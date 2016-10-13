{$REQUIRE_CSS,menu__select}
{$REQUIRE_JAVASCRIPT,core_menus}
{$SET,menu_id,r_{MENU|}}
<div class="menu_type__select" data-view="SelectMenu" data-view-args="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
	{+START,IF,{$JS_ON}}
		<form title="{!MENU} ({!FORM_AUTO_SUBMITS})" method="get" action="#!" autocomplete="off">
			<div class="constrain_field">
				<div class="accessibility_hidden"><label for="menu_select_{MENU|}">{!MENU}</label></div>
				<select id="menu_select_{MENU|}" name="menu_select_{MENU|}" class="wide_field js-change-redirect-to-value">
					{CONTENT}
				</select>
			</div>
		</form>
	{+END}
	{+START,IF,{$NOT,{$JS_ON}}}
		<ul class="nl" id="{$GET*,menu_id}">
			{CONTENT}
		</ul>
	{+END}
</div>
