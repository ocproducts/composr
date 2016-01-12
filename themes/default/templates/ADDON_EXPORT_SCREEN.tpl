{TITLE}

<h2>{!EXPORT_LANGUAGE}</h2>

{+START,IF_NON_EMPTY,{LANGUAGES}}
	{LANGUAGES}
{+END}
{+START,IF_EMPTY,{LANGUAGES}}
	<p class="nothing_here">{!NONE_EM}</p>
{+END}

<h3>{!EXPORT_THEME}</h3>

{+START,IF_NON_EMPTY,{THEMES}}
	{THEMES}
{+END}
{+START,IF_EMPTY,{THEMES}}
	<p class="nothing_here">{!NONE_EM}</p>
{+END}

<h3>{!EXPORT_FILES}</h3>

{+START,IF_NON_EMPTY,{FILES}}
	<form title="{!EXPORT_ADDON}" action="{URL*}" method="post">
		<div>
			{FILES}
		</div>

		<p>
			<input onclick="disable_button_just_clicked(this);" class="menu___generic_admin__export button_screen_item" type="submit" value="{!EXPORT_ADDON}" />
		</p>
	</form>
{+END}
{+START,IF_EMPTY,{FILES}}
	<p class="nothing_here">{!NONE_EM}</p>
{+END}

