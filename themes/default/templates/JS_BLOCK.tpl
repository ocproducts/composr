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

{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
<script type="application/json" data-tpl-core="jsBlock">{+START,PARAMS_JSON,js_block_id,block_call_url}{_/}{+END}</script>
