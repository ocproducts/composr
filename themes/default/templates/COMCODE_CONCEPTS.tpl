<div class="comcode_concepts">
	<div class="box box___comcode_concepts"><div class="box_inner">
		{+START,IF_NON_EMPTY,{TITLE}}
			<h2>{TITLE}</h2>
		{+END}

		<dl>
			{+START,LOOP,CONCEPTS}
				<dt class="de_th comcode_concepts_title"><a id="{A*}"></a>{KEY*}</dt>
				<dd class="comcode_concepts_content">{VALUE}</dd>

				{$SET_TUTORIAL_LINK,{A},{$SELF_PAGE_LINK}#{A}}
			{+END}
		</dl>
	</div></div>
</div>
