<div class="float_surrounder">
	<div class="cns_avatar_page_old_avatar">
		{+START,IF_NON_EMPTY,{PHOTO}}
			<img class="cns_topic_post_avatar" alt="{!PHOTO}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{PHOTO}}" />
		{+END}
		{+START,IF_EMPTY,{PHOTO}}
			{!NONE_EM}
		{+END}
	</div>

	<div class="cns_avatar_page_text">
		<p>{!PHOTO_CHANGE,{$DISPLAYED_USERNAME*,{USERNAME}}}</p>

		{TEXT}

		{+START,IF_NON_EMPTY,{PHOTO}}
			<form title="{$WCASE,{!DELETE_PHOTO}}" action="{$SELF_URL*}#tab__edit__photo" method="post" class="inline" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<p>
					<input type="hidden" name="delete_photo" value="1" />
					{!YOU_CAN_DELETE_PHOTO,<input class="button_hyperlink" type="submit" value="{!DELETE_PHOTO}" />}
				</p>
			</form>
		{+END}
	</div>
</div>
