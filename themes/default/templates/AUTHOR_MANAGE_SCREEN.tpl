{TITLE}

<h2>{!DEFINE_AUTHOR}</h2>

{DEFINE_FORM}

<div class="box"><div class="box-inner">
	<p class="help-jumpout">
		{!STAR_ALREADY_DEFINED}
	</p>
</div></div>

{+START,IF_NON_EMPTY,{MERGE_FORM}}
	<hr class="spaced-rule" />

	<h2>{!MERGE_AUTHORS}</h2>

	{MERGE_FORM}
{+END}
