{+START,IF,{$OR,{$NEQ,{$PAGE},members},{$NEQ,{IMG},buttons--new-quote}}}
	{+START,IF,{$NOT,{IMMEDIATE}}}
		<a data-tpl="buttonScreenItem" data-tpl-params="{+START,PARAMS_JSON,ONCLICK_CALL_FUNCTIONS,ONMOUSEDOWN_CALL_FUNCTIONS}{_*}{+END}" class="{IMG*} button-screen-item"{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}{+START,IF_PASSED,REL} rel="{REL*}"{+END}{+START,IF_PASSED,EXTRA_ATRRS} {EXTRA_ATTRS}{+END} href="{URL*}"><span>{TITLE*}</span></a>
	{+END}

	{+START,IF,{IMMEDIATE}}
		<form data-tpl="buttonScreenItem" title="{TITLE*}" class="inline" action="{URL*}"{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} method="post" autocomplete="off">
			{+START,IF_PASSED,HIDDEN}{$INSERT_SPAMMER_BLACKHOLE}{HIDDEN}{+END}<input class="{IMG*} button-screen-item" type="submit" value="{TITLE*}" title="{FULL_TITLE*}" />
		</form>
	{+END}
{+END}
