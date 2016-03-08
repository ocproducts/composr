<section class="box box___simple_preview_box"><div class="box_inner">
	{+START,IF_NON_EMPTY,{META_TITLE}}
		<h3>
			{META_TITLE`}
		</h3>
	{+END}

	{+START,IF_NON_EMPTY,{IMAGE_URL}}
		<div class="left float_separation"><a href="{URL*}"><img alt="" src="{$THUMBNAIL*,{IMAGE_URL},{WIDTH}}" /></a></div>
	{+END}

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<div class="float_surrounder">
			{$PARAGRAPH,{DESCRIPTION`}}
		</div>
	{+END}

	<p class="shunted_button">
		<a class="button_screen_item buttons__more" href="{URL*}"><span>{!VIEW}</span></a>
	</p>
</div></section>
