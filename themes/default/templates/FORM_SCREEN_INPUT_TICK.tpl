{+START,IF,{$JS_ON}}{+START,IF,{$EQ,{NAME},validated}}<span class="validated_checkbox{+START,IF,{CHECKED}} checked{+END}"></span>{+END}{+END}<input{+START,IF,{$JS_ON}}{+START,IF,{$EQ,{NAME},validated}} onclick="this.previousSibling.className='validated_checkbox'+(this.checked?' checked':'');"{+END}{+END} tabindex="{TABINDEX*}" class="input_tick" type="checkbox" id="{NAME*}" name="{NAME*}" value="{+START,IF_PASSED,VALUE}{VALUE*}{+END}{+START,IF_NON_PASSED,VALUE}1{+END}"{+START,IF,{CHECKED}} checked="checked"{+END} />
<input name="tick_on_form__{NAME*}" value="0" type="hidden" />

{+START,IF,{$EQ,{NAME},delete}}
	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			assign_tick_deletion_confirm('{NAME;/}');
		});
	//]]></script>
{+END}
