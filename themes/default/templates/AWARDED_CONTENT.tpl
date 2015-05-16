<div class="float_surrounder">
	<div class="award_extra_details">
		<h3>{AWARD_DATE*}</h3>

		{+START,IF_NON_EMPTY,{AWARDEE_USERNAME}}
			<p class="additional_details">
				{!AWARDED_TO,<a href="{AWARDEE_PROFILE_URL*}">{$DISPLAYED_USERNAME*,{AWARDEE_USERNAME}}</a>}
			</p>
		{+END}
	</div>

	<div class="award_main">
		{CONTENT}
	</div>
</div>
