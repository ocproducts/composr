{+START,IF_PASSED_AND_TRUE,GET}
	<a{+START,IF_PASSED_AND_TRUE,CONFIRM} data-cms-confirm-click="{!Q_SURE*}"{+END} class="link-exempt vertical-alignment" href="{URL*}"{+START,IF_PASSED_AND_TRUE,NEW_WINDOW} title="{ACTION_TITLE*}: {NAME*} {!LINK_NEW_WINDOW}"{+END}{+START,IF_PASSED_AND_TRUE,NEW_WINDOW} target="_blank"{+END}><img width="14" height="14" src="{$IMG*,icons/{ICON}}" title="{ACTION_TITLE*}: {NAME*}" alt="{ACTION_TITLE*}: {NAME*}" /></a>
{+END}
{+START,IF_NON_PASSED_OR_FALSE,GET}
	<form class="inline top-vertical-alignment" action="{URL*}" method="post" autocomplete="off" title="{ACTION_TITLE*}: {NAME*}{+START,IF_PASSED_AND_TRUE,NEW_WINDOW} {!LINK_NEW_WINDOW}{+END}"{+START,IF_PASSED_AND_TRUE,NEW_WINDOW} target="_blank"{+END}><input type="image" width="14" height="14" src="{$IMG*,icons/{ICON}}" title="{ACTION_TITLE*}: {NAME*}" alt="{ACTION_TITLE*}: {NAME*}" />{+START,IF_PASSED,HIDDEN}{$INSERT_SPAMMER_BLACKHOLE}{+START,IF_PASSED,HIDDEN}{HIDDEN}{+END}{+END}</form>
{+END}
