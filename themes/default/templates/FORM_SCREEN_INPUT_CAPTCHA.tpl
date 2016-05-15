<div class="captcha">
	<a onclick="return play_self_audio_link(this);" target="_blank" title="{!captcha:PLAY_AUDIO_VERSION} {!LINK_NEW_WINDOW}" href="{$FIND_SCRIPT*,captcha,1}?mode=audio{$KEEP*,0,1}">{!captcha:PLAY_AUDIO_VERSION}</a>
	{+START,IF,{$CONFIG_OPTION,css_captcha}}
		<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} id="captcha_readable" class="captcha_frame" title="{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" src="{$FIND_SCRIPT*,captcha}{$KEEP*,1,1}">{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}</iframe>
	{+END}
	{+START,IF,{$NOT,{$CONFIG_OPTION,css_captcha}}}
		<img id="captcha_readable" title="{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" alt="{!captcha:CONTACT_STAFF_TO_JOIN_IF_IMPAIRED}" src="{$FIND_SCRIPT*,captcha}{$KEEP*,1,1}" />
	{+END}
</div>
<div class="accessibility_hidden"><label for="captcha">{!captcha:AUDIO_CAPTCHA}</label></div>
<input{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} maxlength="6" size="7" class="input_text_required" value="" type="text" id="captcha" name="captcha" />

<script>// <![CDATA[
	var showevent=(typeof window.onpageshow!='undefined')?'pageshow':'load';

	var func=function() {
		document.getElementById('captcha_readable').src+='&'; // Force it to reload latest captcha
	};

	if (typeof window.addEventListener!='undefined')
	{
		window.addEventListener(showevent,func,false);
	}
	else if (typeof window.attachEvent!='undefined')
	{
		window.attachEvent('on'+showevent,func);
	}
//]]></script>
