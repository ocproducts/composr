<div class="radio_list_picture{+START,IF_EMPTY,{CODE}} radio_list_picture_na{+END}{+START,IF_PASSED_AND_TRUE,LINEAR} linear{+END}" id="w_{NAME|*}_{CODE|*}">
	<img class="selectable_theme_image" src="{URL*}" alt="{!SELECT_IMAGE}: {$STRIP_TAGS,{PRETTY*}}"{+START,IF_PASSED,WIDTH}{+START,IF_PASSED,HEIGHT} title="{!SELECT_IMAGE}: {$STRIP_TAGS,{PRETTY*}} ({WIDTH*}&times;{HEIGHT*})"{+END}{+END} />

	<label for="j_{NAME|*}_{CODE|*}">
		<input class="input_radio" type="radio" id="j_{NAME|*}_{CODE|*}" name="{NAME*}" value="{CODE*}"{+START,IF,{CHECKED}} checked="checked"{+END} />
		{PRETTY*}
	</label>
</div>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		initialise_input_theme_image_entry('{NAME|;}','{CODE|;}');
	});
//]]></script>
