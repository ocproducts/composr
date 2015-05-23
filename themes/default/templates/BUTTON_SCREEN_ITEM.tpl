{+START,IF,{$NOT,{IMMEDIATE}}}<a class="{IMG*} button_screen_item"{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}{+START,IF_PASSED,REL} rel="{REL*}"{+END}{+START,IF_PASSED,JAVASCRIPT} onclick="{JAVASCRIPT*}"{+END} href="{URL*}"><span>{TITLE*}</span></a>{+END}{+START,IF,{IMMEDIATE}}<form title="{TITLE*}" class="inline" action="{URL*}"{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END} method="post">{$INSERT_SPAMMER_BLACKHOLE}{+START,IF_PASSED,HIDDEN}{HIDDEN}{+END}<input name="submit" class="{IMG*} button_screen_item" type="submit" value="{TITLE*}" title="{FULL_TITLE*}" /></form>{+END}


