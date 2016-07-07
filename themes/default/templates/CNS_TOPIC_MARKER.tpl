{+START,IF,{$JS_ON}}
	<td id="cell_mark_{ID*}" class="cns_topic_marker_cell">
		<form class="webstandards_checker_off inline" title="{!MARKER} #{ID*}" method="post" action="index.php" id="form_mark_{ID*}" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div class="inline">
				{+START,IF,{$NOT,{$IS_GUEST}}}<div class="accessibility_hidden"><label for="mark_{ID*}">{!MARKER} #{ID*}</label></div>{+END}{$,Guests don't see this so search engines don't; hopefully people with screen-readers are logged in}
				<input{+START,IF,{$NOT,{$IS_GUEST}}} title="{!MARKER} #{ID*}"{+END} value="1" type="checkbox" id="mark_{ID*}" name="mark_{ID*}" onclick="change_class(this,this.parentNode.parentNode.parentNode.parentNode,'cns_on','cns_off')" />
			</div>
		</form>
	</td>
{+END}
