<td onclick="/*Access-note: code has other activation*/ var e=this.getElementsByTagName('input')[0]; e.checked=!e.checked;">
	<div class="accessibility_hidden"><label for="{NAME*}">{HUMAN*}</label></div>
	<input onclick="cancel_bubbling(event); return true;" onblur="this.onmouseout(event);" onfocus="this.onmouseover(event);" onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{HUMAN;*}','20%');" alt="{HUMAN*}" type="checkbox" id="{NAME*}" name="{NAME*}"{+START,IF,{CHECKED}} checked="checked"{+END} value="1" />
</td>

