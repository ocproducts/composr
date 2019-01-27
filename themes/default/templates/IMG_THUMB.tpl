{+START,IF,{$NOT,{JS_TOOLTIP}}}
	<img class="img-thumb" alt="{$STRIP_TAGS,{CAPTION*}}"{+START,IF_NON_EMPTY,{CAPTION}} title="{$STRIP_TAGS,{CAPTION*}}"{+END} src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" />
{+END}
{+START,IF,{JS_TOOLTIP}}
	<img class="img-thumb" alt="{$STRIP_TAGS,{CAPTION*}}"{+START,IF_NON_EMPTY,{CAPTION}} data-mouseover-activate-tooltip="['{CAPTION;^=}','40%']"{+END} src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" />
{+END}
