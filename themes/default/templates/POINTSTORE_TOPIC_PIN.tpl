<div class="pointstore_item">
	<div class="box box___pointstore_topic_pin"><div class="box_inner">
		<h2>{!TOPIC_PINNING}</h2>

		<p>
			{!TOPIC_PINNING_DESCRIPTION}
		</p>

		{+START,IF_NON_EMPTY,{NEXT_URL}}
			<ul class="horizontal_links associated_links_block_group">
				<li><a title="{!ENTER}: {!TOPIC_PINNING}" href="{NEXT_URL*}">{!ENTER}</a></li>
			</ul>
		{+END}
	</div></div>
</div>
