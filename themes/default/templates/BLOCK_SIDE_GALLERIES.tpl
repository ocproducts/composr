{+START,IF_NON_EMPTY,{CONTENT}}
	<section class="box box___block_side_galleries"><div class="box-inner">
		<h3>{!GALLERIES}</h3>

		<div class="side-galleries-block">
			{+START,IF,{$NOT,{DEPTH}}}
				<ul class="compact-list">{CONTENT}</ul>
			{+END}
			{+START,IF,{DEPTH}}
				{CONTENT}
			{+END}
		</div>
	</div></section>
{+END}
