{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<img class="leave_native_tooltip help_icon{+START,IF_PASSED_AND_TRUE,LEFT} left{+END}{+START,IF_PASSED_AND_TRUE,RIGHT} right{+END}" onkeypress="this.onclick(event);" title="{$STRIP_TAGS,{DESCRIPTION*}}" onmouseover="return preactivate_rich_semantic_tooltip(this,event,true);" alt="{$STRIP_TAGS,{DESCRIPTION*}}" src="{$IMG*,icons/24x24/buttons/help}" srcset="{$IMG*,icons/48x48/buttons/help} 2x" />
{+END}
