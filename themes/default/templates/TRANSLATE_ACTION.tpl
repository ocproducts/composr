{+START,IF,{$JS_ON}}
	<a href="#" onclick="event.returnValue=false; translate('{NAME;*}','{OLD;^*}{$,Intentionally no further escaping as it's implicit in lang string encodings}','{LANG_FROM;*}','{LANG_TO;*}'); return false;"><img src="{$IMG*,icons/14x14/translate}" srcset="{$IMG*,icons/28x28/translate} 2x" title="{!AUTO_TRANSLATE}" alt="{!AUTO_TRANSLATE}" /></a>
{+END}
