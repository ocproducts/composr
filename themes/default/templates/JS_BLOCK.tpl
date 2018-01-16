{$SET,js_block_id,js_block_{$RAND%}}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
<div data-tpl="jsBlock" data-tpl-params="{+START,PARAMS_JSON,js_block_id,block_call_url}{_*}{+END}">
	<div id="{$GET%,js_block_id}">
		<div aria-busy="true" class="spaced">
			<div class="ajax-loading vertical-alignment">
				<img src="{$IMG*,loading}" width="{$IMG_WIDTH*,{$IMG,loading}}" height="{$IMG_HEIGHT*,{$IMG,loading}}" title="{!LOADING}" alt="{!LOADING}" />
				<span>{!LOADING}</span>
			</div>
		</div>

		<!-- Block will load in here -->
	</div>
</div>
