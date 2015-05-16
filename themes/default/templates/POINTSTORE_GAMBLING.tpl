<div class="pointstore_item">
	<div class="box box___pointstore_gambling"><div class="box_inner">
		<h2>{!GAMBLING}</h2>

		<p>
			{!GAMBLING_DESCRIPTION}
		</p>

		{+START,IF_NON_EMPTY,{NEXT_URL}}
			<ul class="horizontal_links associated_links_block_group">
				<li><a title="{!ENTER}: {!GAMBLING}" href="{NEXT_URL*}">{!ENTER}</a></li>
			</ul>
		{+END}
	</div></div>
</div>
