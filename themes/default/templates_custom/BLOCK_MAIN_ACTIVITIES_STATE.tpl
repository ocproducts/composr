{$REQUIRE_JAVASCRIPT,activity_feed}

<div id="status_updates" class="float-surrounder" data-view="BlockMainActivitiesState">
	{+START,IF_NON_EMPTY,{TITLE}}
		<h2 class="status_icon">{TITLE*}</h2>
	{+END}

	<form id="fp_status_form" class="js-form-status-updates" action="#!" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<input type="hidden" name="zone" value="{$?,{$ZONE},{$ZONE*},frontpage}" />
		<input type="hidden" name="page" value="{$PAGE*}" />

		<div class="status_controls">
			{+START,IF,{$ADDON_INSTALLED,chat}}
				<select name="privacy" size="1">
					<option selected="selected">
						{!PUBLIC}
					</option>
					<option>
						{!FRIENDS_ONLY}
					</option>
				</select>
			{+END}
			{+START,IF,{$NOT,{$ADDON_INSTALLED,chat}}}
				<input type="hidden" name="privacy" value="{!PUBLIC}" />
			{+END}
			<input data-disable-on-click="1" type="submit" class="button_screen_item buttons__save js-btn-submit-update" name="button" id="button" value="{!UPDATE}" />
			<p id="activities_update_notify" class="activities_update_success js-el-activities-update-notification">254 {!activities:CHARACTERS_LEFT}</p> {$,Do not remove; the AJAX notifications are inserted here.}
		</div>

		<div class="status_box_outer">
			<label class="accessibility_hidden" for="activity_status">{!TYPE_HERE}</label>
			<textarea class="status_box fade_input field_input_non_filled js-textarea-activity-status" name="status" id="activity_status" rows="2">{!TYPE_HERE}</textarea>
		</div>
	</form>
</div>
