<iframe title="Facebook Video" src="https://www.facebook.com/video/embed?video_id={REMOTE_ID*}" width="{WIDTH*}" height="{HEIGHT*}" frameborder="0">Facebook Video</iframe>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated_details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}
