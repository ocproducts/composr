<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
	<td class="addon_name">
		{+START,SET,description}
			{DESCRIPTION}

			<p>
				<span class="field_name">{!ORGANISATION}:</span>
				{ORGANISATION*}
			</p>
			{+START,IF_NON_EMPTY,{COPYRIGHT_ATTRIBUTION}}
				<span class="field_name">{!COPYRIGHT_ATTRIBUTION}:</span>
				<div class="whitespace_visible">{COPYRIGHT_ATTRIBUTION*}</div>
			{+END}
			<p>
				<span class="field_name">{!LICENCE}:</span>
				{LICENCE*}
			</p>
			<p>
				<span class="field_name">{!CATEGORY}:</span>
				{CATEGORY*}
			</p>
		{+END}
		<p onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{$GET;^*,description}'.replace(/\n/g,'\n&lt;br /&gt;'),'50%');">
			{PRETTY_NAME}
		</p>
		<p onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{FILE_LIST;^*}'.replace(/\n/g,'\n&lt;br /&gt;'),'50%');">
			{FILENAME*}
		</p>
	</td>
	<td>
		{AUTHOR*}
	</td>
	<td>
		{VERSION*}
	</td>
	<td class="status_{COLOUR*}">
		{STATUS*}
	</td>
	<td class="results_table_field addon_actions">
		{ACTIONS}

		<label class="accessibility_hidden" for="install_{NAME*}">{!INSTALL} {NAME*}</label>
		<input title="{!INSTALL} {NAME*}" type="checkbox" name="install_{NAME*}" id="install_{NAME*}" value="{PASSTHROUGH*}" {$?,{$EQ,{TYPE},install},,disabled="disabled" }/>

		<label class="accessibility_hidden" for="uninstall_{NAME*}">{!UNINSTALL} {NAME*}</label>
		<input title="{!UNINSTALL} {NAME*}" type="checkbox" name="uninstall_{NAME*}" id="uninstall_{NAME*}" value="{PASSTHROUGH*}" {$?,{$EQ,{TYPE},uninstall},,disabled="disabled" }/>
	</td>
</tr>

