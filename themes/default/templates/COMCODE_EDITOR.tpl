<div class="posting_form_insert_buttons">
	<span>{!INSERT}:</span>
	{BUTTONS}
</div>

{+START,IF_NON_EMPTY,{MICRO_BUTTONS}}
<p class="accessibility_hidden"><label for="f_face">{!FONT}</label></p>
<p class="accessibility_hidden"><label for="f_size">{!SIZE}</label></p>
<p class="accessibility_hidden"><label for="f_colour">{!COLOUR}</label></p>

<div class="posting_form_wrap_buttons">
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
		<option value="0.8">0.8</option>
		<option value="1">1</option>
		<option value="1.5">1.5</option>
		<option value="2">2</option>
		<option value="2.5">2.5</option>
		<option value="3">3</option>
		<option value="4">4</option>
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

	<a href="#" onclick="do_input_font('{POSTING_FIELD;*}'); return false;"><img title="{!INPUT_COMCODE_font}" alt="{!INPUT_COMCODE_font}" src="{$IMG*,comcodeeditor/apply_changes}" /></a>
</div>
{+END}
