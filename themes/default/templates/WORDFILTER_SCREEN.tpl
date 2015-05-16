{TITLE}

<h2>{!EDIT}</h2>

<p>
	{!OBSCENITY_WARNING}
</p>

{+START,IF_NON_EMPTY,{TPL}}
	<div class="box">
		<h3 class="toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{!PROCEED}</a>
		</h3>

		<div class="toggleable_tray" style="display: {$JS_ON,none,block}" aria-expanded="false">
			{TPL}
		</div>
	</div>
{+END}
{+START,IF_EMPTY,{TPL}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

<h2>{!ADD_WORDFILTER}</h2>

<p>{!HELP_ADD_WORDFILTER}</p>

{+START,IF_NON_PASSED_OR_FALSE,SKIP_REQUIRED_NOTICE}
	{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
{+END}

{ADD_FORM}

