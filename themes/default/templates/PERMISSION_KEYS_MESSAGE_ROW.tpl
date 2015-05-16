<tr class="{$CYCLE,zebra,zebra_0,zebra_1}">
	<td>
		<label class="accessibility_hidden" for="mkey_{UID*}">{!MATCH_KEY}</label>
		<div class="constrain_field">
			<input maxlength="255" class="wide_field" type="text" id="mkey_{UID*}" name="mkey_{UID*}" value="{KEY*}" />
		</div>
	</td>
	<td>
		<label class="accessibility_hidden" for="msg_{UID*}">{!MATCH_KEY}</label>
		<div class="constrain_field">
			<textarea onfocus="this.setAttribute('rows','10');" onblur="if (!this.form.disable_size_change) this.setAttribute('rows','2');" cols="40" rows="2" class="wide_field" id="msg_{UID*}" name="msg_{UID*}">{MSG*}</textarea>
		</div>
	</td>
</tr>
