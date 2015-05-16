<div aria-labeledby="t_{$GET|*,tab_sets}_{TITLE|*}" role="tabpanel" id="g_{$GET|*,tab_sets}_{TITLE|*}" style="display: {$?,{$OR,{DEFAULT},{$NOT,{$JS_ON}}},block,none}">
	{+START,IF_PASSED,PAGE_LINK}
		<div class="spaced"><div class="ajax_tree_list_loading vertical_alignment"></div></div>

		<script>// <![CDATA[
			function load_tab__{TITLE|/}()
			{
				call_block(
					'{$FACILITATE_AJAX_BLOCK_CALL;,block=main_include_module\,param={PAGE_LINK},raw=.*}',
					'',
					document.getElementById('g_{TITLE|/}')
				);
			}
		//]]></script>
	{+END}

	{+START,IF_PASSED,CONTENT}
		{CONTENT}
	{+END}
</div>
