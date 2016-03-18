<div class="hit_counter">
	<div class="box box___block_main_count"><div class="box_inner">
		{+START,IF,{$LT,{$LENGTH,{VALUE}},2}}0{+END}{+START,IF,{$LT,{$LENGTH,{VALUE}},3}}0{+END}{+START,IF,{$LT,{$LENGTH,{VALUE}},4}}0{+END}{+START,IF,{$LT,{$LENGTH,{VALUE}},5}}0{+END}{VALUE*}
	</div></div>
</div>

{+START,IF_PASSED,UPDATE}
	<script>// <![CDATA[
		load_snippet('count','name={UPDATE;/}');
	//]]></script>
{+END}
