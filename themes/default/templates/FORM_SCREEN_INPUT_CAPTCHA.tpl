{+START,SET,CAPTCHA}
	<div class="captcha">
		{+START,IF,{$CONFIG_OPTION,audio_captcha}}
			<a onclick="return play_self_audio_link(this);" title="{!captcha:PLAY_AUDIO_VERSION}" href="{$FIND_SCRIPT*,captcha,1}?mode=audio{$KEEP*,0,1}&amp;cache_break={$RAND}">{!captcha:PLAY_AUDIO_VERSION}</a>
		{+END}
		{+START,IF,{$CONFIG_OPTION,css_captcha}}
			<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} id="captcha_readable" class="captcha_frame" title="{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" src="{$FIND_SCRIPT*,captcha}{$KEEP*,1,1}&amp;cache_break={$RAND}">{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}</iframe>
		{+END}
		{+START,IF,{$NOT,{$CONFIG_OPTION,css_captcha}}}
			<img id="captcha_readable" title="{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" alt="{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" src="{$FIND_SCRIPT*,captcha}{$KEEP*,1,1}&amp;cache_break={$RAND}" />
		{+END}
	</div>
	<div class="accessibility_hidden"><label for="captcha">{!captcha:AUDIO_CAPTCHA}</label></div>
	<input{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} maxlength="6" size="7" class="input_text_required" value="" type="text" id="captcha" name="captcha" />
{+END}

<div data-tpl="formScreenInputCaptcha" data-tpl-args="{+START,PARAMS_JSON,CAPTCHA}{_*}{+END}">
{+START,IF,{$CONFIG_OPTION,js_captcha}}
	<noscript>{!JAVASCRIPT_REQUIRED}</noscript>

	<div id="captcha_spot"></div>
{+END}
{+START,IF,{$NOT,{$CONFIG_OPTION,js_captcha}}}
	{$GET,CAPTCHA}
{+END}
</div>