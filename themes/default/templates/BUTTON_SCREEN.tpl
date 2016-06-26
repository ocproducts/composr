{+START,IF,{$NOR,{$AND,{$EQ,{IMG},buttons__new_topic},{$MOBILE},{$MATCH_KEY_MATCH,_WILD:topicview}},{$EQ,{IMG},buttons__search,buttons__expand,buttons__contract}}}{+START,IF,{$NOT,{IMMEDIATE}}}<a class="{IMG*} button_screen"{+START,IF_PASSED,REL} rel="{REL*}"{+END} href="{URL*}"><span>{TITLE*}</span></a>{+END}{+START,IF,{IMMEDIATE}}<form title="{TITLE*}" class="inline" action="{URL*}" method="post" autocomplete="off"><input type="submit" class="{IMG*} button_screen" value="{TITLE*}" /></form>{+END}{+END}


