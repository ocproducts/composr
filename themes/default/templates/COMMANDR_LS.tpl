<p class="lonely_label">{DIRECTORY*}:</p>

{$,We do separate lists for accessibility reasons}

{+START,IF_NON_EMPTY,{DIRECTORIES}}
	<ul aria-label="{!LISTING_DIRECTORIES}">
		{$SET,listing,0}

		{+START,LOOP,DIRECTORIES}
			<li class="commandr_dir" onclick="/*Access-note: code has other activation*/ var c=document.getElementById('commandr_command'); c.value='cd &quot;{FILENAME;*}&quot;'; click_link(c.nextSibling);">
				{FILENAME*}

				{+START,IF_NON_EMPTY,{FILESIZE}}
					<span class="commandr_ls_associated_details">({!FILE_SIZE}: {FILESIZE*})</span>
				{+END}
				{+START,IF_NON_EMPTY,{MTIME}}
					<span class="commandr_ls_associated_details">({!MODIFIED}: {MTIME*})</span>
				{+END}
			</li>
			{$SET,listing,1}
		{+END}
	</ul>
{+END}

{+START,IF_NON_EMPTY,{FILES}}
	<ul aria-label="{!LISTING_FILES}">
		{+START,LOOP,FILES}
			<li class="commandr_file" onclick="/*Access-note: code has other activation*/ var c=document.getElementById('commandr_command'); if (c.value!='') { c.value=c.value.replace(/\s*$/,'')+' &quot;{FILENAME;*}&quot;'; c.focus(); } else { c.value='cat &quot;{FILENAME;*}&quot;'; click_link(c.nextSibling); }">
				{FILENAME*}

				{+START,IF_NON_EMPTY,{FILESIZE}}
					<span class="commandr_ls_associated_details">({!_SIZE}: {FILESIZE*})</span>
				{+END}
				{+START,IF_NON_EMPTY,{MTIME}}
					<span class="commandr_ls_associated_details">({!_MODIFIED}: {MTIME*})</span>
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
