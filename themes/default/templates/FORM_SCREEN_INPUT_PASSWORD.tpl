<div class="constrain_field">
	{+START,IF,{$MATCH_KEY_MATCH,:join}}
		<div style="display: none" onmouseover="if (typeof this.parentNode.title!='undefined') this.parentNode.title=''; if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{!PASSWORD_STRENGTH}','auto');" id="password_strength_{NAME*}" class="password_strength">
			<div class="password_strength_inner"></div>
		</div>
	{+END}

	<input{+START,IF,{$EQ,{NAME},edit_password}} autocomplete="off"{+START,IF,{$MOBILE}} autocorrect="off"{+END}{+END} onchange="if (typeof window.password_strength!='undefined') password_strength(this);" size="30" maxlength="255" tabindex="{TABINDEX*}" class="input_password{REQUIRED*}" type="password" id="{NAME*}" name="{NAME*}" value="{VALUE*}" />

	{+START,IF,{$AND,{$EQ,{VALUE},},{$EQ,{NAME},edit_password}}}
		<script type="text/javascript">// <![CDATA[
			// Work around annoying Firefox bug. It ignores autocomplete="off" if a password was already saved somehow
			add_event_listener_abstract(window,'load',function () {
				window.setTimeout(function() {
					document.getElementById('{NAME;/}').value='';
				},300);
			} );
		//]]></script>
	{+END}
</div>

