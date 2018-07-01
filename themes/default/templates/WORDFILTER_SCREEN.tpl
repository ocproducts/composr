{TITLE}

<h2>{!EDIT}</h2>

<p>
	{!OBSCENITY_WARNING}
</p>

{+START,IF_NON_EMPTY,{TPL}}
	<div class="box" data-toggleable-tray="{}">
		<div class="box-inner">
			<h3 class="toggleable-tray-title js-tray-header">
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!" title="{!EXPAND}">
					{+START,INCLUDE,ICON}
					NAME=trays/expand
					ICON_SIZE=24
					{+END}
				</a>
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!PROCEED}</a>
			</h3>

			<div class="toggleable-tray js-tray-content" style="display: none" aria-expanded="false">
				{TPL}
			</div>
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
