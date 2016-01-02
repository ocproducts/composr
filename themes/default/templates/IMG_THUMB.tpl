{+START,IF,{$NOT,{JS_TOOLTIP}}}
	<img alt="{$STRIP_TAGS,{CAPTION^*~}}" title="{$STRIP_TAGS,{CAPTION*}}" class="img_thumb" src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" />
{+END}
{+START,IF,{JS_TOOLTIP}}
	<img alt="{$STRIP_TAGS,{CAPTION^*~}}" class="img_thumb"{+START,IF_NON_EMPTY,{CAPTION}} onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{CAPTION;^*}','40%');" onmouseout="if (typeof window.deactivate_tooltip!='undefined') deactivate_tooltip(this);"{+END} src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" />
{+END}
