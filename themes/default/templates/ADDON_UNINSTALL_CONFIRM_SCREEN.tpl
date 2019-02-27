{TITLE}

{WARNINGS}

{+START,IF_NON_EMPTY,{FILES}}
	<p class="lonely-label">{!WARNING_UNINSTALL}</p>
	<ul>
		{FILES}
	</ul>
{+END}

<div class="right">
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
		{$INSERT_SPAMMER_BLACKHOLE}

		<input type="hidden" name="name" value="{NAME*}" />

		<p>
			<button class="btn btn-primary btn-scr buttons--back" type="button" data-cms-btn-go-back="1">{+START,INCLUDE,ICON}NAME=buttons/back{+END} {!GO_BACK}</button>

			<button class="btn btn-danger btn-scr" type="submit">{+START,INCLUDE,ICON}NAME=admin/delete3{+END} {!PROCEED}</button>
		</p>
	</form>
</div>
