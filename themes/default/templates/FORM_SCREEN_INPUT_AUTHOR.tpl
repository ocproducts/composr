{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div data-tpl="formScreenInputAuthor">
	<span class="invisible_ref_point"></span>
	<input {+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" size="27" maxlength="80" tabindex="{TABINDEX*}" class="input-author{REQUIRED*} js-keyup-update-ajax-author-list wide-field" type="text" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}" />
</div>
