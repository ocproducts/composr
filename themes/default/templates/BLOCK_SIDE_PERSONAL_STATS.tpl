<section class="box box___block_side_personal_stats"><div class="box-inner">
	<h3>{$DISPLAYED_USERNAME*,{USERNAME}}</h3>

	{+START,IF_NON_EMPTY,{AVATAR_URL}}
		<div class="personal_stats_avatar"><img src="{$ENSURE_PROTOCOL_SUITABILITY*,{AVATAR_URL}}" title="{!AVATAR}" alt="{!AVATAR}" /></div>
	{+END}

	{+START,IF_NON_EMPTY,{DETAILS}}
		<ul class="compact-list">
			{DETAILS}
		</ul>
	{+END}

	{+START,IF_NON_EMPTY,{LINKS_ECOMMERCE}}
		<ul class="associated-links-block-group">
			{LINKS_ECOMMERCE}
		</ul>
	{+END}

	{+START,IF_NON_EMPTY,{LINKS}}
		<ul class="associated-links-block-group">
			{LINKS}
		</ul>
	{+END}
</div></section>
