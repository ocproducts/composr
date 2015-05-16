<div class="pointstore_item">
	<div class="box box___pointstore_community_billboard_2"><div class="box_inner">
		<h2>{!COMMUNITY_BILLBOARD_MESSAGE}</h2>

		<p>
			{!COMMUNITY_BILLBOARD_MESSAGE_DESCRIPTION}
		</p>

		{+START,IF_NON_EMPTY,{COMMUNITY_BILLBOARD_URL}}
			<ul class="horizontal_links associated_links_block_group">
				<li><a title="{!ENTER}: {!COMMUNITY_BILLBOARD_MESSAGE}" href="{COMMUNITY_BILLBOARD_URL*}">{!ENTER}</a></li>
			</ul>
		{+END}
	</div></div>
</div>
