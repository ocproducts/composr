{$,Used by rarely used combo_get_image_paths function -- you probably want to be looking at FORM_SCREEN_INPUT_THEME_IMAGE_ENTRY.tpl}

<div class="float_surrounder">
	<div class="left">
		{+START,IF,{$NOT,{CHECKED}}}
			<input class="input_radio" type="radio" id="{NAME*}_{VALUE|*}" name="{NAME*}" value="{VALUE*}" />
		{+END}
		{+START,IF,{CHECKED}}
			<input class="input_radio" type="radio" id="{NAME*}_{VALUE|*}" name="{NAME*}" value="{VALUE*}" checked="checked" />
		{+END}
	</div>
	<div class="left">
		<label for="{NAME*}_{VALUE|*}"><img src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" alt="{!SELECT_IMAGE}: {$STRIP_TAGS,{PRETTY*}}" title="" /><br />
		{URL*}</label>
	</div>
</div>

<hr />
