<div data-tpl="formScreenInputTreeList" data-tpl-args="{+START,PARAMS_JSON,NAME,HOOK,ROOT_ID,OPTIONS,MULTI_SELECT,TABINDEX,USE_SERVER_ID}{_*}{+END}">
{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}
DESCRIPTION={+START,IF_NON_EMPTY,{DESCRIPTION}}{DESCRIPTION}<br /><br />{+END}{!TREE_LIST_HELP,{$?,{_REQUIRED},{!TREE_LIST_HELP_DESELECT}},{$?,{$EQ,{$PAGE},admin_sitemap,admin_permissions},{!TREE_LIST_HELP_MASS_EXPAND}},{CONTENT_TYPE}}
RIGHT=1
{+END}

<input style="display: none" type="text" class="input_line{REQUIRED*} hidden_but_needed" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}" onchange="var ob=document.getElementById('{NAME;*}_mirror'); if (ob) { ob.parentNode.style.display=(this.selected_title=='')?'none':'block'; $cms.dom.html(ob,(this.selected_title=='')?'{!NA_EM;=}':escape_html(this.selected_title)); }" />
<div class="ajax_tree_list" id="tree_list__root_{NAME*}" role="tree">
	<!-- List put in here -->
</div>

{+START,IF_NON_EMPTY,{DEFAULT}}
	<p class="associated_details">
		{!TREE_LIST_FEEDBACK,<span class="whitespace_visible" id="{NAME*}_mirror">{NICE_LABEL*}</span>}
	</p>
{+END}
</div>
