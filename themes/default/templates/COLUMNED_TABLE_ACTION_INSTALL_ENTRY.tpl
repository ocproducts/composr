{+START,IF_NON_PASSED_OR_FALSE,GET}
	<form title="{!INSTALL}: {NAME*}" data-disable-buttons-on-submit="{}" class="inline top-vertical-alignment" action="{URL*}" method="post" autocomplete="off"><input type="image" width="14" height="14" src="{$IMG*,icons/28x28/install}" title="{!INSTALL}: {NAME*}" alt="{!INSTALL}: {NAME*}" />{+START,IF_NON_EMPTY,{HIDDEN}}{$INSERT_SPAMMER_BLACKHOLE}{HIDDEN}{+END}</form>
{+END}
{+START,IF_PASSED_AND_TRUE,GET}
	<a class="link-exempt vertical-alignment" href="{URL*}"><img width="14" height="14" src="{$IMG*,icons/28x28/install}" title="{!INSTALL}: {NAME*}" alt="{!INSTALL}: {NAME*}" /></a>
{+END}
