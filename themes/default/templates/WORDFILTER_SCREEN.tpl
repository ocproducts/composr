{TITLE}

<h2>{!EDIT}</h2>

<p>
	{!OBSCENITY_WARNING}
</p>

{+START,IF_NON_EMPTY,{TPL}}
	<div class="box" data-toggleable-tray="{}">
		<h3 class="toggleable-tray-title js-tray-header">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" /></a>
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!PROCEED}</a>
		</h3>

		<div class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
			{TPL}
		</div>
	</div>
{+END}
{+START,IF_EMPTY,{TPL}}
	<p class="nothing-here">
		{!NO_ENTRIES}
	</p>
{+END}

<h2>{!ADD_WORDFILTER}</h2>

<p>{!HELP_ADD_WORDFILTER}</p>

{+START,IF_NON_PASSED_OR_FALSE,SKIP_REQUIRED_NOTICE}
	{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
{+END}

{ADD_FORM}
