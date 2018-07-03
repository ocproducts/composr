<div class="fields_set_item">
	<div class="fields_set_radio">
		<input type="radio" name="{SET_NAME*}" id="choose_{NAME*}" />
		<label for="choose_{NAME*}"><span class="accessibility_hidden">{!CHOOSE}</span> {PRETTY_NAME*}</label>

		{COMCODE}
	</div>

	<div class="mini_indent fields_set_contents vertical_alignment">
		{$SET,show_label,{$AND,{$IS_NON_EMPTY,{NAME}},{$NOT,{SKIP_LABEL}}}}
		{+START,IF,{$GET,show_label}}
			<label class="accessibility_hidden" for="{NAME*}">{PRETTY_NAME*}</label>

			<input type="hidden" name="label_for__{NAME*}" value="{$STRIP_HTML,{PRETTY_NAME*}}" />
		{+END}

		{INPUT}

		{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}{+END}

		<div id="error_{NAME*}" style="display: none" class="input_error_here"></div>

		{+START,IF,{REQUIRED}}
			<input type="hidden" id="required_posted__{NAME*}" name="require__{NAME*}" value="1" />
		{+END}

		<script>// <![CDATA[
			set_up_change_monitor('form_table_field_input__{NAME;/}');
		//]]></script>
	</div>
</div>
