<td onclick="$cms.dom.toggleChecked(this.querySelector('input'));">
	<div class="accessibility_hidden"><label for="{NAME*}">{HUMAN*}</label></div>
	<input onclick="cancel_bubbling(event);" onblur="this.onmouseout(event);" data-focus-activate-tooltip="['{HUMAN;*}','20%']" data-mouseover-activate-tooltip="['{HUMAN;*}','20%']" alt="{HUMAN*}" type="checkbox" id="{NAME*}" name="{NAME*}"{+START,IF,{CHECKED}} checked="checked"{+END} value="1" />
</td>

