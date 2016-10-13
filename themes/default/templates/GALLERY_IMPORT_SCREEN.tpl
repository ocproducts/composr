<div data-tpl="galleryImportScreen">
{$REQUIRE_JAVASCRIPT,galleries}

{TITLE}

{+START,IF_NON_EMPTY,{FORM2}}
	<h2>{!BATCH_IMPORT_ARCHIVE_CONTENTS}</h2>
{+END}

{FORM}

{+START,IF_NON_EMPTY,{FORM2}}
	<div class="orphaned_content">
		<h2>{!ORPHANED_IMAGES}</h2>

		{FORM2}
	</div>
{+END}
</div>