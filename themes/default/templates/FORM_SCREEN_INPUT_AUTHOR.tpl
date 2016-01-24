<div class="constrain_field">
	<span class="invisible_ref_point"></span><input{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" size="{$?,{$MOBILE},30,40}" maxlength="80" tabindex="{TABINDEX*}" onkeyup="update_ajax_author_list(this,event);" class="input_author{REQUIRED*}" type="text" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}" />
</div>

