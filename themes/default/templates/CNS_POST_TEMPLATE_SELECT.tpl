{$REQUIRE_JAVASCRIPT,cns_post_templates}
<div data-tpl="cnsPostTemplateSelect" data-tpl-params="{+START,PARAMS_JSON,RESETS}{_*}{+END}">
<div class="accessibility_hidden"><label for="post_template">{!POST_TEMPLATE}</label></div>
<select{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} id="post_template" name="post_template">
	{LIST}
</select>
<input class="button_screen_item buttons__proceed js-click-reset-and-insert-textbox" data-cms-js="1" type="submit" value="{!USE}" />
</div>