{+START,IF_ARRAY_NON_EMPTY,MISSING_LANG_STRINGS}
	<section class="box box___broken_lang_strings"><div class="box_inner">
		<h3>{!MISSING_LANG_STRINGS}</h3>

		<p>
			{+IMPLODE,&#044; ,MISSING_LANG_STRINGS}
		</p>
	</div></section>
{+END}

{+START,IF_ARRAY_NON_EMPTY,MISSING_LANG_STRINGS_ZERO}
	<section class="box box___broken_lang_strings"><div class="box_inner">
		<h3>{!MISSING_LANG_STRINGS_ZERO}</h3>

		<p>
			{+IMPLODE,&#044; ,MISSING_LANG_STRINGS_ZERO}
		</p>
	</div></section>
{+END}

{+START,IF_ARRAY_NON_EMPTY,FUSED_LANG_STRINGS}
	<section class="box box___broken_lang_strings"><div class="box_inner">
		<h3>{!FUSED_LANG_STRINGS}</h3>

		<p>
			{+IMPLODE,<br /><br />,FUSED_LANG_STRINGS,1}
		</p>
	</div></section>
{+END}

{+START,IF_ARRAY_NON_EMPTY,ORPHANED_LANG_STRINGS}
	<section class="box box___broken_lang_strings"><div class="box_inner">
		<h3>{!ORPHANED_LANG_STRINGS}</h3>

		<p>
			{+IMPLODE,&#044; ,ORPHANED_LANG_STRINGS}
		</p>
	</div></section>
{+END}

