{$SET,ajax_block_main_poll_wrapper,ajax_block_main_poll_wrapper_{$RAND%}}
<div id="{$GET*,ajax_block_main_poll_wrapper}" class="box_wrapper">
	{CONTENT}

	{$REQUIRE_JAVASCRIPT,ajax}
	{$REQUIRE_JAVASCRIPT,checking}

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			internalise_ajax_block_wrapper_links('{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}',document.getElementById('{$GET;,ajax_block_main_poll_wrapper}'),['.*poll.*'],{ },false,true);
		});
	//]]></script>
</div>
