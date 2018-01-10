{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,core_adminzone_dashboard}

{$SET,RAND_STAFF_LINKS,{$RAND}}

<div class="form_ajax_target" data-view="BlockMainStaffLinks" data-view-params="{+START,PARAMS_JSON,RAND_STAFF_LINKS,BLOCK_NAME,MAP}{_*}{+END}">
	<section id="tray_{!EXTERNAL_LINKS|}" data-toggleable-tray="{ save: true }" class="box box___block_main_staff_links">
		<h3 class="toggleable-tray-title js-tray-header">
			<a title="{!EDIT}: {!EXTERNAL_LINKS}" href="#!" class="top-left-toggleicon js-click-staff-block-flip">{!EDIT}</a>

			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{!EXTERNAL_LINKS}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" /></a>

			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!EXTERNAL_LINKS}</a>
		</h3>

		<div class="toggleable-tray js-tray-content">
			<ol id="staff_links_list_{$GET%,RAND_STAFF_LINKS}" class="spaced-list">
				{+START,LOOP,FORMATTED_LINKS}
					<li><a target="_blank" title="{TITLE*} {!LINK_NEW_WINDOW}" href="{URL*}">{TITLE*}</a></li>
				{+END}
			</ol>

			<form id="staff_links_list_{$GET%,RAND_STAFF_LINKS}_form" title="{!EDIT}: {!LINKS}" action="{URL*}" method="post" style="display: none" aria-hidden="true" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div><label for="staff_links_edit" class="accessibility-hidden">{!EDIT}</label><textarea cols="100" rows="30" id="staff_links_edit" name="staff_links_edit" class="wide-field">{+START,LOOP,UNFORMATTED_LINKS}{LINKS*}&#10;&#10;{+END}</textarea></div>

				<div class="buttons-group">
					<input data-disable-on-click="1" class="button_screen_item buttons--save {+START,IF,{$HAS_PRIVILEGE,comcode_dangerous}}js-click-form-submit-headless{+END}" type="submit" value="{!SAVE}" />
				</div>
			</form>
		</div>
	</section>
</div>
