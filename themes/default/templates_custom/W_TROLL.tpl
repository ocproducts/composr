{TITLE}

<p>
	{!W_ANGRY_TROLL,{TROLL*}}
</p>

<form action="{$PAGE_LINK*,_SELF:_SELF}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{QUESTIONS}
	<p><button class="button-screen buttons--proceed" type="submit">{!PROCEED} {+START,INCLUDE,ICON}NAME=buttons/proceed{+END}</button></p>
</form>
