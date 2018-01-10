<section class="box box___simple_preview_box"><div class="box-inner">
	{+START,IF_NON_EMPTY,{META_TITLE}}
		<h3>
			{META_TITLE`}
		</h3>
	{+END}

	{+START,IF_NON_EMPTY,{IMAGE_URL}}
		<div class="left float-separation"><a href="{URL*}"><img alt="" src="{$THUMBNAIL*,{IMAGE_URL},{WIDTH}}" /></a></div>
	{+END}

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<div class="float-surrounder">
			{$PARAGRAPH,{DESCRIPTION`}}
		</div>
	{+END}

	<p class="shunted-button">
		<a class="button-screen-item buttons--more" href="{URL*}"><span>{!VIEW}</span></a>
	</p>
</div></section>
