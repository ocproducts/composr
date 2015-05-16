<figure class="attachment">
	<figcaption>{!_ATTACHMENT}</figcaption>
	<div>
		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			{$PARAGRAPH,{DESCRIPTION}}
		{+END}

		{+START,INCLUDE,MEDIA__DOWNLOAD_LINK}{+END}
	</div>
</figure>

