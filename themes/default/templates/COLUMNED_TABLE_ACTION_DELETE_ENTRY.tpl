{+START,IF_NON_PASSED_OR_FALSE,GET}
	<form title="{!DELETE}: {NAME*}" class="inline top-vertical-alignment" action="{URL*}" method="post" autocomplete="off"><input type="image" width="14" height="14" src="{$IMG*,icons/28x28/delete}" title="{!DELETE}: {NAME*}" alt="{!DELETE}: {NAME*}" />{+START,IF_PASSED,HIDDEN}{$INSERT_SPAMMER_BLACKHOLE}{HIDDEN}{+END}</form>
{+END}
{+START,IF_PASSED_AND_TRUE,GET}
	<a data-cms-confirm-click="{!Q_SURE*}" class="link-exempt vertical-alignment" href="{URL*}"><img width="14" height="14" src="{$IMG*,icons/28x28/delete}" title="{!DELETE}: {NAME*}" alt="{!DELETE}: {NAME*}" /></a>
{+END}
