<form title="{$STRIP_TAGS,{CAPTION}}" action="{URL*}" method="post" class="inline"{+START,IF_PASSED_AND_TRUE,NEW_WINDOW} target="_blank"{+END} autocomplete="off">
	{+START,IF_NON_EMPTY,{POST_DATA}}
		{$INSERT_SPAMMER_BLACKHOLE}
		{POST_DATA}
	{+END}

	<div class="inline">
		<input{+START,IF_PASSED,ACCESSKEY} accesskey="{ACCESSKEY*}"{+END} class="button_hyperlink"{+START,IF_PASSED_AND_TRUE,NEW_WINDOW} title="{+START,IF_NON_EMPTY,{TITLE}}{$STRIP_TAGS*,{TITLE},1} {+END}{!NEW_WINDOW}"{+END} type="submit" value="{CAPTION}" />
	</div>
</form>
