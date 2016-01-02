<div class="constrain_field">
	<div class="accessibility_hidden"><label for="{NAME_STUB*}{I*}">{PRETTY_NAME*}</label></div>
	<input{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" maxlength="255" tabindex="{TABINDEX*}" onfocus="if (this.value=='') update_ajax_member_list(this,null,true,event);" class="{+START,IF,{NEEDS_MATCH}}input_username {+END}input_line{REQUIRED*} wide_field" onkeyup="update_ajax_member_list(this,null,false,event);" onchange="ensure_next_field(this);" onkeypress="ensure_next_field(this);" type="text" id="{NAME_STUB*}{I*}" name="{NAME_STUB*}{I*}" value="{DEFAULT*}" />
	<input type="hidden" name="label_for__{NAME_STUB*}{I*}" value="{PRETTY_NAME*}" />
</div>
