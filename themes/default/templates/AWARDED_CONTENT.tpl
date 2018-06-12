<div class="clearfix">
	<div class="award-extra-details">
		<h3>{AWARD_DATE*}</h3>

		{+START,IF_NON_EMPTY,{AWARDEE_USERNAME}}
			<p class="additional-details">
				{!AWARDED_TO,<a href="{AWARDEE_PROFILE_URL*}">{$DISPLAYED_USERNAME*,{AWARDEE_USERNAME}}</a>}
			</p>
		{+END}
	</div>

	<div class="award-main">
		{CONTENT}
	</div>
</div>
