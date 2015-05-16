{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
<div id="{$GET*,wrapper_id}" class="box_wrapper">
	{CONTENT}

	{$REQUIRE_JAVASCRIPT,ajax}
	{$REQUIRE_JAVASCRIPT,checking}

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			internalise_ajax_block_wrapper_links('{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}',document.getElementById('{$GET;,wrapper_id}'),['.*poll.*'],{ },false,true);
		});
	//]]></script>
</div>
