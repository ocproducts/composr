{+START,IF,{$OR,{$NEQ,{$PAGE},members},{$NEQ,{IMG},buttons__new_quote}}}
	{$REQUIRE_JAVASCRIPT,core_abstract_components}

	{+START,IF,{$NOT,{IMMEDIATE}}}
		<a data-tpl="buttonScreenItem" class="{IMG*} button_screen_item" {+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}{+START,IF_PASSED,REL} rel="{REL*}"{+END} {+START,IF_PASSED,EXTRA_ATRRS}{EXTRA_ATTRS}{+END} {+START,IF_PASSED,JAVASCRIPT} data-click-eval="{JAVASCRIPT*}" {+END} href="{URL*}"><span>{TITLE*}</span></a>
	{+END}

	{+START,IF,{IMMEDIATE}}
		<form data-tpl="buttonScreenItem" title="{TITLE*}" class="inline" action="{URL*}"{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} method="post" autocomplete="off">
			{+START,IF_PASSED,HIDDEN}{$INSERT_SPAMMER_BLACKHOLE}{HIDDEN}{+END}<input class="{IMG*} button_screen_item" type="submit" value="{TITLE*}" title="{FULL_TITLE*}" />
		</form>
	{+END}
{+END}
