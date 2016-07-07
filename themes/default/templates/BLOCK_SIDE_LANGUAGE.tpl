<section class="box box___block_side_language"><div class="box_inner">
	<h3>{!LANGUAGE}</h3>

	<form title="{!LANGUAGE} ({!FORM_AUTO_SUBMITS})" method="get" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}" autocomplete="off">
		{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1},keep_lang}
		<div>
			<p class="accessibility_hidden"><label for="keep_lang">{!LANGUAGE}</label></p>
			<select{+START,IF,{$JS_ON}} onchange="/*guarded*/this.form.submit();"{+END} id="keep_lang" name="keep_lang" class="wide_field">
				{LANGS}
			</select>
			{+START,IF,{$NOT,{$JS_ON}}}
				<p class="proceed_button">
					<input onclick="disable_button_just_clicked(this);" type="submit" value="{!PROCEED}" class="button_screen_item buttons__proceed" />
				</p>
			{+END}
		</div>
	</form>
</div></section>
