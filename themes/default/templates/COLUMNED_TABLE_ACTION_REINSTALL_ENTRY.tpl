{+START,IF_NON_PASSED_OR_FALSE,GET}
<form title="{!REINSTALL}: {NAME*}" onsubmit="disable_button_just_clicked(this);" class="inline top_vertical_alignment" action="{URL*}" method="post" autocomplete="off"><input type="image" src="{$IMG*,icons/14x14/reinstall}" srcset="{$IMG*,icons/28x28/reinstall} 2x" title="{!REINSTALL}: {NAME*}" alt="{!REINSTALL}: {NAME*}" />{+START,IF_NON_EMPTY,{HIDDEN}}{$INSERT_SPAMMER_BLACKHOLE}{HIDDEN}{+END}</form>
{+END}
{+START,IF_PASSED_AND_TRUE,GET}
<a class="link_exempt vertical_alignment" href="{URL*}"><img src="{$IMG*,icons/14x14/reinstall}" srcset="{$IMG*,icons/28x28/reinstall} 2x" title="{!REINSTALL}: {NAME*}" alt="{!REINSTALL}: {NAME*}" /></a>
{+END}
