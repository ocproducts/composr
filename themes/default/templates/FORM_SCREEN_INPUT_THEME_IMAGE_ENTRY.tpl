<div class="radio-list-picture{+START,IF_EMPTY,{CODE}} radio-list-picture-na{+END}{+START,IF_PASSED_AND_TRUE,LINEAR} linear{+END}" id="w-{NAME|*}-{CODE|*}" data-tpl="formScreenInputThemeImageEntry" data-tpl-params="{+START,PARAMS_JSON,NAME,CODE}{_*}{+END}">
	<img class="selectable-theme-image"{+START,IF,{VECTOR}} width="80"{+END} src="{URL*}" alt="{!SELECT_IMAGE}: {$STRIP_TAGS,{PRETTY*}}"{+START,IF_PASSED,WIDTH}{+START,IF_PASSED,HEIGHT} title="{!SELECT_IMAGE}: {$STRIP_TAGS,{PRETTY*}}{+START,IF,{$NOT,{VECTOR}}} ({WIDTH*}&times;{HEIGHT*}){+END}"{+END}{+END} />

	<label for="j-{NAME|*}-{CODE|*}">
		<input class="input-radio" type="radio" id="j-{NAME|*}-{CODE|*}" name="{NAME*}" value="{CODE*}"{+START,IF,{CHECKED}} checked="checked"{+END} />
		{PRETTY*}
	</label>
</div>
