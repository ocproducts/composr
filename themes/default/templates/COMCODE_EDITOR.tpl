{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div data-tpl="comcodeEditor" data-tpl-params="{+START,PARAMS_JSON,POSTING_FIELD}{_*}{+END}">
	<div class="posting-form-insert-buttons">
		<span>{!ADD}:</span>
		{BUTTONS}
	</div>

	{+START,IF_NON_EMPTY,{MICRO_BUTTONS}}
		<p class="accessibility-hidden"><label for="f_face">{!FONT}</label></p>
		<p class="accessibility-hidden"><label for="f_size">{!SIZE}</label></p>
		<p class="accessibility-hidden"><label for="f_colour">{!COLOUR}</label></p>

		<div class="posting-form-wrap-buttons">
			{MICRO_BUTTONS}

			<select id="f_face" name="f_face">
				<option value="/">[{!FONT}]</option>
				<option value="Arial" style="font-family: 'Arial'">Arial</option>
				<option value="Courier" style="font-family: 'Courier'">Courier</option>
				<option value="Georgia" style="font-family: 'Georgia'">Georgia</option>
				<option value="Impact" style="font-family: 'Impact'">Impact</option>
				<option value="Times" style="font-family: 'Times'">Times</option>
				<option value="Trebuchet" style="font-family: 'Trebuchet'">Trebuchet</option>
				<option value="Verdana" style="font-family: 'Verdana'">Verdana</option>
				<option value="Tahoma" style="font-family: 'Tahoma'">Tahoma</option>
				<option value="Geneva" style="font-family: 'Geneva'">Geneva</option>
				<option value="Helvetica" style="font-family: 'Helvetica'">Helvetica</option>
			</select>
			<select id="f_size" name="f_size">
				<option value="">[{!SIZE}]</option>
				{+START,IF,{$EQ,{$CONFIG_OPTION,wysiwyg_font_units},em}}
					{+START,LOOP,0.8\,1\,1.5\,2\,2.5\,3\,4}
						<option value="{_loop_var*}">{_loop_var*}em</option>
					{+END}
				{+END}
				{+START,IF,{$NEQ,{$CONFIG_OPTION,wysiwyg_font_units},em}}
					{+START,LOOP,8\,9\,10\,11\,12\,14\,16\,18\,20\,22\,24\,36\,48\,72}
						<option value="{_loop_var*}px">{_loop_var*}px</option>
					{+END}
				{+END}
			</select>
			<select id="f_colour" name="f_colour">
				<option value="">[{!COLOUR}]</option>
				<option value="black" style="color: black">{!BLACK}</option>
				<option value="blue" style="color: blue">{!BLUE}</option>
				<option value="gray" style="color: gray">{!GRAY}</option>
				<option value="green" style="color: green">{!GREEN}</option>
				<option value="orange" style="color: orange">{!ORANGE}</option>
				<option value="purple" style="color: purple">{!PURPLE}</option>
				<option value="red" style="color: red">{!RED}</option>
				<option value="white" style="color: white">{!WHITE}</option>
				<option value="yellow" style="color: yellow">{!YELLOW}</option>
			</select>

			<a href="#!" class="js-click-do-input-font-posting-field"><img title="{!INPUT_COMCODE_font}" alt="{!INPUT_COMCODE_font}" src="{$IMG*,comcodeeditor/apply_changes}" /></a>
		</div>
	{+END}
</div>
