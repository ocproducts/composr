{+START,IF_NON_EMPTY,{TAGS}}
	<div class="box box---tags"><div class="box-inner">
		<span class="field-name">{!search:TAGS}:</span>
		{$SET,done_one_tag,0}
		<span itemprop="keywords">{+START,LOOP,TAGS}{+START,IF,{$GET,done_one_tag}}, {+END}<a href="{LINK_FULLSCOPE*}">{TAG*}</a>{$SET,done_one_tag,1}{+END}</span>
	</div></div>
{+END}
