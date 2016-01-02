{+START,IF,{$NEQ,{IMG},search,expand,contract}}{+START,IF,{$NOT,{IMMEDIATE}}}<a class="{IMG*} button_screen"{+START,IF_PASSED,REL} rel="{REL*}"{+END} href="{URL*}"><span>{TITLE*}</span></a>{+END}{+START,IF,{IMMEDIATE}}<form title="{TITLE*}" class="inline" action="{URL*}" method="post">{$INSERT_SPAMMER_BLACKHOLE}<input type="submit" class="{IMG*} button_screen" value="{TITLE*}" /></form>{+END}{+END}


