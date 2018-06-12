<div class="cns-edit-forum-grouping">
	<div class="clearfix">
		<div class="cns-edit-forum-type">
			{!FORUM_GROUPING}
		</div>
		<div class="cns-edit-forum-title">
			<h3>{GROUPING*}</h3>
		</div>
		{+START,IF_NON_EMPTY,{ORDERINGS}}
			<div class="cns-edit-forum-orderings">
				{ORDERINGS}
			</div>
		{+END}
	</div>
</div>

{SUBFORUMS}
