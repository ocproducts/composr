{$REQUIRE_JAVASCRIPT,commandr}

<div data-tpl="commandrLs">
	<p class="lonely_label">{DIRECTORY*}:</p>

	{$,We do separate lists for accessibility reasons}

	{+START,IF_NON_EMPTY,{DIRECTORIES}}
		<ul aria-label="{!LISTING_DIRECTORIES}">
			{$SET,listing,0}

			{+START,LOOP,DIRECTORIES}
				<li class="commandr-dir js-click-set-directory-command" data-tp-filename="{FILENAME*}">
					{FILENAME*}

					{+START,IF_NON_EMPTY,{FILESIZE}}
						<span class="commandr-ls-associated-details">({!FILE_SIZE}: {FILESIZE*})</span>
					{+END}
					{+START,IF_NON_EMPTY,{MTIME}}
						<span class="commandr-ls-associated-details">({!MODIFIED}: {MTIME*})</span>
					{+END}
				</li>
				{$SET,listing,1}
			{+END}
		</ul>
	{+END}

	{+START,IF_NON_EMPTY,{FILES}}
		<ul aria-label="{!LISTING_FILES}">
			{+START,LOOP,FILES}
				<li class="commandr-file js-click-set-file-command" data-tp-filename="{FILENAME*}">
					{FILENAME*}

					{+START,IF_NON_EMPTY,{FILESIZE}}
						<span class="commandr-ls-associated-details">({!_SIZE}: {FILESIZE*})</span>
					{+END}
					{+START,IF_NON_EMPTY,{MTIME}}
						<span class="commandr-ls-associated-details">({!_MODIFIED}: {MTIME*})</span>
					{+END}
				</li>
				{$SET,listing,1}
			{+END}

			{+START,IF,{$NOT,{$GET,listing}}}
				<li class="nothing_here">
					{!NONE}
				</li>
			{+END}
		</ul>
	{+END}
</div>
