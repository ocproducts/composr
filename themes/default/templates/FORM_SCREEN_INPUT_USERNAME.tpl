{$REQUIRE_JAVASCRIPT,core_form_interfaces}
<div class="constrain_field" data-tpl="formScreenInputUsername">
    <input {+START,IF,{$EQ,{NAME},edit_username}} autocomplete="off"{+START,IF,{$MOBILE}} autocorrect="off"{+END}{+END} maxlength="255" tabindex="{TABINDEX*}" class="{+START,IF,{NEEDS_MATCH}}input_username{+END}{+START,IF,{$NOT,{NEEDS_MATCH}}}input_line{+END}{REQUIRED*} js-focus-update-ajax-member-list js-keyup-update-ajax-member-list" type="text" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}" />
</div>

