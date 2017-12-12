<section class="box box___simple_preview_box"><div class="box-inner">
	{+START,IF_NON_EMPTY,{TITLE}}
		<h3>
			{TITLE`}
		</h3>
	{+END}

	{+START,IF_NON_EMPTY,{HTML}}
		{HTML`}
	{+END}

	<p class="shunted_button">
		<a class="button_screen_item buttons--more" href="{URL*}"><span>{!VIEW}</span></a>
	</p>
</div></section>
