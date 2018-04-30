{$REQUIRE_JAVASCRIPT,cns_post_templates}

<div data-tpl="cnsPostTemplateSelect" data-tpl-params="{+START,PARAMS_JSON,RESETS}{_*}{+END}">
	<div class="accessibility-hidden"><label for="post_template">{!POST_TEMPLATE}</label></div>
	<select {+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} id="post_template" name="post_template">
		{LIST}
	</select>
	<button class="button-screen-item buttons--proceed js-click-reset-and-insert-textbox" data-click-pd="1" type="submit">{+START,INCLUDE,ICON}NAME=buttons/proceed{+END} {!USE}</button>
</div>
