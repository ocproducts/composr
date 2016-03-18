<nav>
	<ul class="actions_list">
		<li class="actions_list_strong">
			<a{+START,IF,{$NOT,{$INLINE_STATS}}} onclick="return ga_track(this,'{!_ATTACHMENT;*}','{FILENAME;*}');"{+END} class="user_link" rel="enclosure" target="_blank" title="{!_DOWNLOAD,{FILENAME*}} {!LINK_NEW_WINDOW}" href="{URL*}">{!_DOWNLOAD,{FILENAME*}}</a>

			{+START,IF_NON_EMPTY,{CLEAN_FILESIZE}{$GET,num_downloads}}
				{+START,SET,num_downloads}{+START,IF_PASSED,NUM_DOWNLOADS}{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}{+START,IF,{$INLINE_STATS}}{!DOWNLOADS_SO_FAR,{$NUMBER_FORMAT*,{NUM_DOWNLOADS}}}{+END}{+END}{+END}{+END}
				({+START,IF_NON_EMPTY,{CLEAN_FILESIZE}}{CLEAN_FILESIZE*}{+START,IF_NON_EMPTY,{$GET,num_downloads}}, {+END}{+END}{$GET,num_downloads})
			{+END}
		</li>
	</ul>
</nav>
