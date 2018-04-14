<div data-tpl="blockTopPersonalStats">
	<div class="global-button-ref-point" id="top-personal-stats-rel" style="display: none">
		<div class="box box-arrow box--block-top-personal-stats"><span></span><div class="box-inner"><div>
			{+START,IF_NON_EMPTY,{AVATAR_URL}}
				<div class="personal-stats-avatar"><img src="{$ENSURE_PROTOCOL_SUITABILITY*,{AVATAR_URL}}" title="{!AVATAR}" alt="{!AVATAR}" /></div>
			{+END}

			<h3>{$DISPLAYED_USERNAME*,{USERNAME}}</h3>

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
				<ul class="associated-links-block-group horizontal-links">
					{LINKS}
				</ul>
			{+END}
		</div></div></div>
	</div>
	<a title="{$STRIP_TAGS,{!LOGGED_IN_AS,{USERNAME*}}} ({$IP_ADDRESS*}, #{MEMBER_ID*})" id="top-personal-stats-button" class="js-click-toggle-top-personal-stats" href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}">
		{+START,INCLUDE,ICON}
			NAME=content_types/member
			SIZE=20
		{+END}
	</a>
</div>
