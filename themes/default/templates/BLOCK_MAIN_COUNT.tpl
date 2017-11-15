{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_JAVASCRIPT,counting_blocks}

<div class="hit_counter" data-tpl="blockMainCount" data-tpl-params="{+START,PARAMS_JSON,UPDATE}{_*}{+END}">
	<div class="box box___block_main_count"><div class="box_inner">
		{+START,IF,{$LT,{$LENGTH,{VALUE}},2}}0{+END}{+START,IF,{$LT,{$LENGTH,{VALUE}},3}}0{+END}{+START,IF,{$LT,{$LENGTH,{VALUE}},4}}0{+END}{+START,IF,{$LT,{$LENGTH,{VALUE}},5}}0{+END}{VALUE*}
	</div></div>
</div>
