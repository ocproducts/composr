{$REQUIRE_JAVASCRIPT,core_permission_management}

<tr class="{$CYCLE,zebra,zebra_0,zebra_1}" data-tpl="permissionKeysMessageRow">
	<td>
		<label class="accessibility_hidden" for="mkey_{UID*}">{!MATCH_KEY}</label>
		<div>
			<input maxlength="255" class="wide-field" type="text" id="mkey_{UID*}" name="mkey_{UID*}" value="{KEY*}" />
		</div>
	</td>
	<td>
		<label class="accessibility_hidden" for="msg_{UID*}">{!MATCH_KEY}</label>
		<div>
			<textarea cols="40" rows="2" class="wide-field js-focus-textarea-expand js-blur-textarea-contract" id="msg_{UID*}" name="msg_{UID*}">{MSG*}</textarea>
		</div>
	</td>
</tr>
