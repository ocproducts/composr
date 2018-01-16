{$SET,block_call_url}

<div aria-labeledby="t_{$GET|*,tab_sets}_{TITLE|*}" role="tabpanel" id="g_{$GET|*,tab_sets}_{TITLE|*}" data-tpl="comcodeTabBody" data-tpl-params="{+START,PARAMS_JSON,block_call_url,TITLE}{_*}{+END}" style="display: {$?,{DEFAULT},block,none}">
	{+START,IF_PASSED,PAGE_LINK}
		{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,block=main_include_module\,param={PAGE_LINK},raw=.*}}
		<div class="spaced"><div class="ajax-tree-list-loading vertical-alignment"></div></div>
	{+END}

	{+START,IF_PASSED,CONTENT}
		{CONTENT}
	{+END}
</div>
