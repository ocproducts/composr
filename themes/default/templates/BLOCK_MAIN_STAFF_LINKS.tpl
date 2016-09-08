{$REQUIRE_JAVASCRIPT,ajax}
{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,staff}

{$SET,RAND_STAFF_LINKS,{$RAND}}

<div class="form_ajax_target" data-view-core-adminzone-dashboard="BlockMainStaffLinks" data-view-args="{+START,PARAMS_JSON,RAND_STAFF_LINKS,BLOCK_NAME,MAP}{_*}{+END}">
	<section id="tray_{!EXTERNAL_LINKS|}" data-view-core="ToggleableTray" data-tray-cookie="{!EXTERNAL_LINKS|}" class="box box___block_main_staff_links">
		<h3 class="toggleable_tray_title js-tray-header">
			<a title="{!EDIT}: {!EXTERNAL_LINKS}" href="#!" class="top_left_toggleicon js-click-staff-block-flip">{!EDIT}</a>

			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!EXTERNAL_LINKS}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{!EXTERNAL_LINKS}</a>
		</h3>

		<div class="toggleable_tray js-tray-content">
			{+START,IF,{$JS_ON}}
				<ol id="staff_links_list_{$GET%,RAND_STAFF_LINKS}" class="spaced_list">
					{+START,LOOP,FORMATTED_LINKS}
						<li><a target="_blank" title="{TITLE*} {!LINK_NEW_WINDOW}" href="{URL*}">{TITLE*}</a></li>
					{+END}
				</ol>
			{+END}
			<form id="staff_links_list_{$GET%,RAND_STAFF_LINKS}_form" title="{!EDIT}: {!LINKS}" action="{URL*}" method="post" {+START,IF,{$JS_ON}} style="display: none" aria-hidden="true"{+END} autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="constrain_field"><label for="staff_links_edit" class="accessibility_hidden">{!EDIT}</label><textarea cols="100" rows="30" id="staff_links_edit" name="staff_links_edit" class="wide_field">{+START,LOOP,UNFORMATTED_LINKS}{LINKS*}&#10;&#10;{+END}</textarea></div>

				<div class="buttons_group">
					<input data-disable-on-click="1" class="button_screen_item buttons__save {+START,IF,{$HAS_PRIVILEGE,comcode_dangerous}}js-click-form-submit-headless{+END}" type="submit" value="{!SAVE}" />
				</div>
			</form>


		</div>
	</section>
</div>

