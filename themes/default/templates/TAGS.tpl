{+START,IF_NON_EMPTY,{TAGS}}
	<div class="box box___tags"><div class="box_inner">
		<span class="field_name">{!search:TAGS}:</span>
		{$SET,done_one_tag,0}
		<span itemprop="keywords">{+START,LOOP,TAGS}{+START,IF,{$GET,done_one_tag}}, {+END}<a href="{LINK_FULLSCOPE*}">{TAG*}</a>{$SET,done_one_tag,1}{+END}</span>
	</div></div>
{+END}
