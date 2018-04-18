{TITLE}

{WARNINGS}

{+START,IF_NON_EMPTY,{FILES}}
	<p class="lonely-label">{!WARNING_UNINSTALL}</p>
	<ul>
		{FILES}
	</ul>
{+END}

<div class="right">
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<input type="hidden" name="name" value="{NAME*}" />

		<p>
			<button class="button-screen buttons--back" type="button" data-cms-btn-go-back="1">{+START,INCLUDE,ICON}NAME=buttons/back{+END} {!GO_BACK}</button>

			<button class="button-screen admin--delete3" type="submit">{!PROCEED}</button>
		</p>
	</form>
</div>
