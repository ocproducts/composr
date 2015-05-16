{TITLE}

{+START,IF_NON_EMPTY,{PRE}}
	<div itemprop="description">
		{$PARAGRAPH,{PRE}}
	</div>
{+END}

{+START,IF_NON_EMPTY,{CONTENT}}
<ul role="navigation" class="actions_list" itemprop="significantLinks">
	{CONTENT}
</ul>
{+END}
{+START,IF_EMPTY,{CONTENT}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_NON_EMPTY,{POST}}
	{$PARAGRAPH,{POST}}
{+END}

