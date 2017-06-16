{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div class="constrain_field" data-tpl="formScreenInputAuthor">
	<span class="invisible_ref_point"></span>
	<input {+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" size="{$?,{$MOBILE},30,40}" maxlength="80" tabindex="{TABINDEX*}" class="input_author{REQUIRED*} js-keyup-update-ajax-author-list" type="text" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}" />
</div>
