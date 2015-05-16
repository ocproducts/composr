{TITLE}

<h2>{!DEFINE_AUTHOR}</h2>

{DEFINE_FORM}

<div class="box"><div class="box_inner">
	<p class="help_jumpout">
		{!STAR_ALREADY_DEFINED}
	</p>
</div></div>

{+START,IF_NON_EMPTY,{MERGE_FORM}}
	<hr class="spaced_rule" />

	<h2>{!MERGE_AUTHORS}</h2>

	{MERGE_FORM}
{+END}

