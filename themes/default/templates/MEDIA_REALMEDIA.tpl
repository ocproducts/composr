{+START,SET,media}
	{$SET,player_id,player_{$RAND}}

	{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
		{+START,IF_EMPTY,{$METADATA,video}}
			{$METADATA,video,{URL}}
			{$METADATA,video:height,{HEIGHT}}
			{$METADATA,video:width,{WIDTH}}
			{$METADATA,video:type,{MIME_TYPE}}
		{+END}
	{+END}

	<div class="webstandards_checker_off">
		<embed id="{$GET*,player_id}" name="{$GET*,player_id}" type="audio/x-pn-realaudio"
			src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}"
			autostart="false"
			controls="ImageWindow,ControlPanel"
			pluginspage="http://www.real.com"
			width="{WIDTH*}"
			height="{HEIGHT*}"
		></embed>
	</div>

	{$,Tie into callback event to see when finished, for our slideshows}
	{$,API: http://service.real.com/help/library/guides/realone/ScriptingGuide/PDF/ScriptingGuide.pdf}
	<script>// <![CDATA[
		add_event_listener_abstract(window,'real_load',function() {
			if (document.getElementById('next_slide'))
			{
				stop_slideshow_timer();
				window.setTimeout(function() {
					add_event_listener_abstract(document.getElementById('{$GET;,player_id}'),'stateChange',function(newState) { if (newState==0) { player_stopped(); } });
					document.getElementById('{$GET;,player_id}').DoPlay();
				}, 1000);
			}
		});
	//]]></script>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated_details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
{+END}
{+START,IF_PASSED_AND_TRUE,FRAMED}
	<figure>
		{$GET,media}
	</figure>
{+END}
{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
	{$GET,media}
{+END}
