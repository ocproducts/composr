<div class="float_surrounder" itemscope="itemscope" itemtype="http://schema.org/ContactPage">
	{+START,IF_NON_EMPTY,{MESSAGE}}
		<p>
			{MESSAGE}
		</p>
	{+END}

	{COMMENT_DETAILS}

	{+START,IF_PASSED_AND_TRUE,NOTIFICATIONS_ENABLED}
		<div class="right">
			{+START,INCLUDE,NOTIFICATION_BUTTONS}
				NOTIFICATIONS_TYPE=messaging
				NOTIFICATIONS_ID={TYPE}
			{+END}
		</div>
	{+END}
</div>
