{+START,LOOP,NOTIFICATION_TYPES}
	<td>
		<div>
			<label for="notification_{SCOPE*}_{NTYPE*}">{LABEL*}</label>

			{+START,IF,{AVAILABLE}}
				<input onclick="handle_notification_type_tick(this,this.parentNode.parentNode.parentNode,{RAW%});" title="{LABEL*}"{+START,IF,{CHECKED}} checked="checked"{+END} id="notification_{SCOPE*}_{NTYPE*}" name="notification_{SCOPE*}_{NTYPE*}" type="checkbox" value="1" />

				{+START,IF_PASSED_AND_TRUE,TYPE_HAS_CHILDREN_SET}
					<script>// <![CDATA[
						var e=document.getElementById('notification_{SCOPE;/}_{NTYPE;/}');
						if (!e.checked) e.indeterminate=true;
						e.onchange=function() {
							var e=document.getElementById('notification_{SCOPE;/}_{NTYPE;/}');
							if (!e.checked) e.indeterminate=true; // Put back
						};
					//]]></script>
				{+END}
			{+END}

			{+START,IF,{$NOT,{AVAILABLE}}}
				<input title="{LABEL*}" disabled="disabled" id="notification_{SCOPE*}_{NTYPE*}" name="notification_{SCOPE*}_{NTYPE*}" type="checkbox" value="1" />
			{+END}
		</div>
	</td>
{+END}
