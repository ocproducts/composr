{TITLE}

<h2>{!EXPORT_LANGUAGE}</h2>

{$RESET_CYCLE,addon_export}
{+START,IF_NON_EMPTY,{LANGUAGES}}
	{LANGUAGES}
{+END}
{+START,IF_EMPTY,{LANGUAGES}}
	<p class="nothing-here">{!NONE_EM}</p>
{+END}

<h2>{!EXPORT_THEME}</h2>

{$RESET_CYCLE,addon_export}
{+START,IF_NON_EMPTY,{THEMES}}
	{THEMES}
{+END}
{+START,IF_EMPTY,{THEMES}}
	<p class="nothing-here">{!NONE_EM}</p>
{+END}

<h2>{!EXPORT_FILES}</h2>

{+START,IF_NON_EMPTY,{FILES}}
	<form title="{!EXPORT_ADDON}" action="{URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			{FILES}
		</div>

		<p>
			<input data-disable-on-click="1" class="button-screen menu---generic-admin--export" type="submit" value="{!EXPORT_ADDON}" />
		</p>
	</form>
{+END}
{+START,IF_EMPTY,{FILES}}
	<p class="nothing-here">{!NONE_EM}</p>
{+END}
