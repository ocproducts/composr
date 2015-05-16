{$,NB: INTERESTED is what clicking will make it, not what it currently is set to}

{+START,IF_NON_EMPTY,{INTERESTED}}
	<div class="float_surrounder zebra_{$CYCLE%,zebedee,0,1}" onclick="/*Access-note: code has other activation*/ var e=document.getElementById('{S;*}int_{TYPE_ID;*}'); e.checked=!e.checked;">
		<div class="event_interested left">
			<label for="{S*}int_{TYPE_ID*}">{TYPE*}:</label>
		</div>
		<div class="right">
			<input onclick="return cancel_bubbling(event);" type="checkbox" value="1" id="{S*}int_{TYPE_ID*}" name="int_{TYPE_ID*}"{+START,IF,{$EQ,{INTERESTED},not_interested}} checked="checked"{+END} />
		</div>
	</div>
{+END}
