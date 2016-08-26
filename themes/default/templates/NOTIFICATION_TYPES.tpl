{+START,LOOP,NOTIFICATION_TYPES}
	<td>
		<div>
			<label for="notification_{SCOPE*}_{NTYPE*}">{LABEL*}</label>

			{+START,IF,{AVAILABLE}}
				<input onclick="handle_notification_type_tick(this,this.parentNode.parentNode.parentNode,{RAW%});" title="{LABEL*}"{+START,IF,{CHECKED}} checked="checked"{+END} id="notification_{SCOPE*}_{NTYPE*}" name="notification_{SCOPE*}_{NTYPE*}" type="checkbox" value="1" />
			{+END}

			{+START,IF,{$NOT,{AVAILABLE}}}
				<input title="{LABEL*}" disabled="disabled" id="notification_{SCOPE*}_{NTYPE*}" name="notification_{SCOPE*}_{NTYPE*}" type="checkbox" value="1" />
			{+END}
		</div>
	</td>
{+END}
<script type="application/json" data-tpl-core-notifications="notificationTypes">{+START,PARAMS_JSON,NOTIFICATION_TYPES}{_/}{+END}</script>