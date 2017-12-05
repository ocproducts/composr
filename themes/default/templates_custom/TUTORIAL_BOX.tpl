<h3 style="margin-top: 0">{TITLE*}</h3>

<div class="meta_details" role="note" style="width: auto">
	<dl class="meta_details_list">
		{+START,IF_NON_EMPTY,{AUTHOR}}
			<dt class="field_name">{!BY}:</dt> <dd>{AUTHOR*}</dd>
		{+END}

		<dt class="field_name">{!ADDED}:</dt> <dd>{ADD_DATE*}</dd>

		{+START,IF,{$NEQ,{ADD_DATE},{EDIT_DATE}}}
			<dt class="field_name">{!EDITED}:</dt> <dd>{EDIT_DATE*}</dd>
		{+END}

		{+START,IF,{$NEQ,{MEDIA_TYPE},document}}
			<dt class="field_name">Media type:</dt> <dd>{$UCASE*,{MEDIA_TYPE},1}</dd>
		{+END}

		<dt class="field_name">Difficulty:</dt> <dd>{$UCASE*,{DIFFICULTY_LEVEL},1}</dd>

		<dt class="field_name">Tutorial type:</dt> <dd>{$?,{CORE},Core documentation,Auxillary}</dd>

		<dt class="field_name">Tags:</dt>
		<dd>
			<ul class="horizontal-meta-details" style="width: auto">
				{+START,LOOP,TAGS}
					<li><a href="{$PAGE_LINK*,_SEARCH:tutorials:{_loop_var}}">{_loop_var*}</a></li>
				{+END}
			</ul>
		</dd>
	</dl>
</div>

<p style="margin-bottom: 0">{SUMMARY*}</p>
