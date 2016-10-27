{+START,IF_NON_PASSED_OR_FALSE,GET}
<form title="{!DELETE}: {NAME*}" class="inline top_vertical_alignment" action="{URL*}" method="post" autocomplete="off"><input type="image" src="{$IMG*,icons/14x14/delete}" srcset="{$IMG*,icons/28x28/delete} 2x" title="{!DELETE}: {NAME*}" alt="{!DELETE}: {NAME*}" />{+START,IF_PASSED,HIDDEN}{$INSERT_SPAMMER_BLACKHOLE}{HIDDEN}{+END}</form>
{+END}
{+START,IF_PASSED_AND_TRUE,GET}
<a onclick="cancel_bubbling(event,this); var t=this; window.fauxmodal_confirm('{!Q_SURE;*}',function(result) { if (result) { click_link(t); } }); return false;" class="link_exempt vertical_alignment" href="{URL*}"><img src="{$IMG*,icons/14x14/delete}" srcset="{$IMG*,icons/28x28/delete} 2x" title="{!DELETE}: {NAME*}" alt="{!DELETE}: {NAME*}" /></a>
{+END}
