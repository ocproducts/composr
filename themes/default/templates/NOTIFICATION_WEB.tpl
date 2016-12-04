<div class="notification notification_priority__{PRIORITY*} notification_code__{NOTIFICATION_CODE*} notification_{$?,{HAS_READ},has_read,has_not_read}">
	{+START,IF_NON_EMPTY,{FROM_AVATAR_URL}}
		<img class="right spaced" src="{$ENSURE_PROTOCOL_SUITABILITY*,{FROM_AVATAR_URL}}" title="{FROM_USERNAME*}" alt="{FROM_USERNAME*}" />
	{+END}

	<p class="notification_subject">
		{+START,IF_PASSED,URL}
			<a href="{URL*}">{SUBJECT*}</a>
		{+END}

		{+START,IF_NON_PASSED,URL}
			<a onclick="poll_for_notifications(true,true); return open_link_as_overlay(this);" href="{$PAGE_LINK*,_SEARCH:notifications:view:{ID}}">{SUBJECT*}</a>
		{+END}
	</p>

	<ul class="notification_meta horizontal_meta_details">
		<li>{DATE_WRITTEN_TIME*}</li>
		<li>({$?,{HAS_READ},{!notifications:HAS_READ},{!notifications:HAS_NOT_READ}})</li>
	</ul>
</div>
