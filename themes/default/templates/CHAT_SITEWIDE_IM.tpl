<script>// <![CDATA[
	{+START,IF,{$NOT,{$MATCH_KEY_MATCH,_WILD:chat:browse}}}
		var im_area_template='{IM_AREA_TEMPLATE;^/}';
		var im_participant_template='{IM_PARTICIPANT_TEMPLATE;^/}';
		var top_window=window;
		var lobby_link='{$PAGE_LINK;,_SEARCH:chat:browse:enter_im=!!}';
		var participants='';

		add_event_listener_abstract(window,'real_load',function () {
			if (!window.load_from_room_id) // Only if not in chat lobby or chatroom, so as to avoid conflicts
			{
				function begin_im_chatting()
				{
					window.load_from_room_id=-1;
					if ((window.chat_check) && (window.do_ajax_request)) chat_check(true,0); else window.setTimeout(begin_im_chatting,100);
				}
				add_event_listener_abstract(window,'load',function() {
					begin_im_chatting();
				});
			}
		});
	{+END}
// ]]></script>

{CHAT_SOUND}
