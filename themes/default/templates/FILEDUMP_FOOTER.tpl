<hr class="spaced_rule" />

<div class="float_surrounder">
	<div class="left">
		<label for="action_{I*}">{!ACTION}:</label>
		<select id="action_{I*}" name="action">
			{+START,IF,{$EQ,{I},1}}
				<option value="">---</option>
			{+END}
			{+START,IF,{$EQ,{I},2}}
				<option value="edit">{!EDIT_DESCRIPTIONS}</option>
			{+END}
			<option value="delete">{!DELETE_SELECTED}</option>
			{+START,LOOP,OTHER_DIRECTORIES}
				<option value="/{_loop_var*}{+START,IF_NON_EMPTY,{_loop_var}}/{+END}">{!MOVE_TO,/{_loop_var*}}</option>
			{+END}
			<option value="zip">{!FILEDUMP_ZIP}</option>
		</select>

		<input type="submit" value="{!PROCEED}" class="button_micro buttons__proceed" />
	</div>
</div>
