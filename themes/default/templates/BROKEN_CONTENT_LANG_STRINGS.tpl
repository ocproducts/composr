{+START,IF_ARRAY_NON_EMPTY,MISSING_CONTENT_LANG_STRINGS}
	<section class="box box---broken-lang-strings"><div class="box-inner">
		<h3>{!MISSING_CONTENT_LANG_STRINGS}</h3>

		<p>
			{+IMPLODE,&#044; ,MISSING_CONTENT_LANG_STRINGS}
		</p>
	</div></section>
{+END}

{+START,IF_ARRAY_NON_EMPTY,MISSING_CONTENT_LANG_STRINGS_ZERO}
	<section class="box box---broken-lang-strings"><div class="box-inner">
		<h3>{!MISSING_CONTENT_LANG_STRINGS_ZERO}</h3>

		<p>
			{+IMPLODE,&#044; ,MISSING_CONTENT_LANG_STRINGS_ZERO}
		</p>
	</div></section>
{+END}

{+START,IF_ARRAY_NON_EMPTY,FUSED_CONTENT_LANG_STRINGS}
	<section class="box box---broken-lang-strings"><div class="box-inner">
		<h3>{!FUSED_CONTENT_LANG_STRINGS}</h3>

		<p>
			{+IMPLODE,<br /><br />,FUSED_CONTENT_LANG_STRINGS,1}
		</p>
	</div></section>
{+END}

{+START,IF_ARRAY_NON_EMPTY,ORPHANED_CONTENT_LANG_STRINGS}
	<section class="box box---broken-lang-strings"><div class="box-inner">
		<h3>{!ORPHANED_CONTENT_LANG_STRINGS}</h3>

		<p>
			{+IMPLODE,&#044; ,ORPHANED_CONTENT_LANG_STRINGS}
		</p>
	</div></section>
{+END}
