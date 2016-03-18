{$SET,js_block_id,js_block_{$RAND%}}

<div>
	<div id="{$GET%,js_block_id}">
		<div aria-busy="true" class="spaced">
			<div class="ajax_loading vertical_alignment">
				<img id="loading_image" src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
				<span>{!LOADING}</span>
			</div>
		</div>

		<!-- Block will load in here -->
	</div>
</div>

<script>// <![CDATA[
	add_event_listener_abstract(window,'real_load',function() {
		call_block('{$FACILITATE_AJAX_BLOCK_CALL;,{BLOCK_PARAMS}}','',document.getElementById('{$GET%,js_block_id}'),false,null,false,null,false,false);
	});
//]]></script>
