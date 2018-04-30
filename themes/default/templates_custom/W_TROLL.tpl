{TITLE}

<p>
	{!W_ANGRY_TROLL,{TROLL*}}
</p>

<form action="{$PAGE_LINK*,_SELF:_SELF}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{QUESTIONS}
	<p><button class="button-screen buttons--proceed" type="submit">{+START,INCLUDE,ICON}NAME=buttons/proceed{+END} {!PROCEED}</button></p>
</form>
