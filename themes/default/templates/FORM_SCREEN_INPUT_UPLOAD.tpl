{+START,IF,{$AND,{IS_IMAGE},{$IS_NON_EMPTY,{EXISTING_URL}}}}
<img class="upload_field_image_preview" src="{$ENSURE_PROTOCOL_SUITABILITY*,{EXISTING_URL}}" title="" alt="{!EXISTING;^}" />
{+END}

<div class="upload_field inline_block">
	<div class="vertical_alignment inline_block">
		<input tabindex="{TABINDEX*}" class="input_upload{REQUIRED*}" type="file" id="{NAME*}" name="{NAME*}" />
		{+START,IF,{EDIT}}
			<p class="upload_field_msg inline_block">
				<input type="checkbox" id="i_{NAME*}_unlink" name="{NAME*}_unlink" value="1" />
				<label for="i_{NAME*}_unlink">
					{+START,IF,{$NOT,{$AND,{IS_IMAGE},{$IS_NON_EMPTY,{EXISTING_URL}}}}}
						{!UNLINK_EXISTING_UPLOAD}
					{+END}
					{+START,IF,{$AND,{IS_IMAGE},{$IS_NON_EMPTY,{EXISTING_URL}}}}
						{!UNLINK_EXISTING_UPLOAD_IMAGE,{$GET*,image_preview}}
					{+END}
				</label>
			</p>
		{+END}

		{+START,IF,{$AND,{$JS_ON},{$BROWSER_MATCHES,gecko}}}<input class="button_micro buttons__clear" type="button" id="clear_button_{NAME*}" value="{!CLEAR}" onclick="var x=document.getElementById('{NAME;*}'); x.value=''; if (typeof x.fakeonchange!='undefined' &amp;&amp; x.fakeonchange) x.fakeonchange(event); return false;" title="{!CLEAR}{+START,IF_PASSED,PRETTY_NAME}: {PRETTY_NAME*}{+END}" />{+END}
	</div>

	{+START,IF_PASSED,SYNDICATION_JSON}
		<div id="{NAME*}_syndication_options" class="syndication_options"></div>
	{+END}

	{+START,IF,{PLUPLOAD}}{+START,IF,{$NOT,{$IS_HTTPAUTH_LOGIN}}}
		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function() {
				preinit_file_input('upload','{NAME;/}',null,null,'{FILTER;/}');
			});
		//]]></script>
	{+END}{+END}

	{+START,IF_PASSED,SYNDICATION_JSON}
		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function() {
				show_upload_syndication_options('{NAME;/}','{SYNDICATION_JSON;/}');
			});
		//]]></script>
	{+END}
</div>
