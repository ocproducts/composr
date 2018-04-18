{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		{SECTIONS}

		<p class="proceed-button">
			<button accesskey="u" data-disable-on-click="1" class="button-screen buttons--save" type="submit">{+START,INCLUDE,ICON}NAME=buttons/save{+END} {!SAVE}</button>
		</p>
	</div>
</form>
