<div class="fields_set_item">
	<div class="fields_set_radio">
		<label class="accessibility_hidden" for="choose_{NAME*}">{!USE}: {PRETTY_NAME*}</label>
		<input type="radio" name="{SET_NAME*}" id="choose_{NAME*}" />

		<label for="{NAME*}">{PRETTY_NAME*}</label>

		{COMCODE}
	</div>

	<div class="mini_indent fields_set_contents vertical_alignment">
		{INPUT}

		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<input type="hidden" name="label_for__{NAME*}" value="{$STRIP_HTML,{PRETTY_NAME*}}" />
		{+END}
		{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}{+END}

		<div id="error_{NAME*}" style="display: none" class="input_error_here"></div>

		<input type="hidden" id="required_posted__{NAME*}" name="require__{NAME*}" value="{$?,{REQUIRED*},1,0}" />

		<script>// <![CDATA[
			set_up_change_monitor('form_table_field_input__{NAME;/}');
		//]]></script>
	</div>
</div>
