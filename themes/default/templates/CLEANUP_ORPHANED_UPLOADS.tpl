{+START,IF_ARRAY_NON_EMPTY,FOUND}
	<section class="box box___cleanup_orphaned_uploads"><div class="box_inner">
		<h3>{!ORPHANED_UPLOADS}</h3>

		{+START,LOOP,FOUND}
			<p><a href="{URL*}">{PATH*}</a></p>
		{+END}
	</div></section>
{+END}

