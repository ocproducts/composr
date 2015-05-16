<p>{$?,{$ADDON_INSTALLED,content_privacy},{!PRIVACY_SETTINGS_INTRO_EXTRA},{!PRIVACY_SETTINGS_INTRO}}</p>

{+START,IF_EMPTY,{FIELDS}}
	<p class="nothing_here">{!NO_ENTRIES}</p>
{+END}
