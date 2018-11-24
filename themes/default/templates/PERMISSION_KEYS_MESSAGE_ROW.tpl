{$REQUIRE_JAVASCRIPT,core_permission_management}

<tr class="{$CYCLE,zebra,zebra-0,zebra-1}" data-tpl="permissionKeysMessageRow">
	<td>
		<label class="accessibility-hidden" for="mkey_{UID*}">{!MATCH_KEY}</label>
		<div>
			<input maxlength="255" class="form-control form-control-wide" type="text" id="mkey_{UID*}" name="mkey_{UID*}" value="{KEY*}" />
		</div>
	</td>
	<td>
		<label class="accessibility-hidden" for="msg_{UID*}">{!MATCH_KEY}</label>
		<div>
			<textarea cols="40" rows="2" class="form-control form-control-wide js-focus-textarea-expand js-blur-textarea-contract" id="msg_{UID*}" name="msg_{UID*}">{MSG*}</textarea>
		</div>
	</td>
</tr>
