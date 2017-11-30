{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,core_adminzone_dashboard}

<div class="form_ajax_target" data-require-javascript="core_adminzone_dashboard" data-view="BlockMainNotes" data-view-params="{+START,PARAMS_JSON,BLOCK_NAME,MAP}{_*}{+END}">
	<section id="tray_{TITLE|}" data-toggleable-tray="{ save: true }" class="box box___block_main_notes">
		<h3 class="toggleable_tray_title js-tray-header">
			<a class="toggleable_tray_button" data-click-tray-toggle="#tray_{TITLE|}" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{TITLE}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" /></a>

			{+START,IF_NON_EMPTY,{TITLE}}
				<a class="toggleable_tray_button" data-click-tray-toggle="#tray_{TITLE|}" href="#!">{TITLE*}</a>
			{+END}
		</h3>

		<div class="toggleable_tray js-tray-content">
			<form title="{$STRIP_TAGS,{TITLE}}" method="post" action="{URL*}" autocomplete="off" class="js-form-block-main-notes">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="accessibility_hidden"><label for="n_block_{TITLE|}">{!NOTES}</label></div>
				<div>
					<textarea class="wide_field js-focus-textarea-expand js-blur-textarea-contract{+START,IF,{SCROLLS}} textarea_scroll{+END}" cols="80" id="n_block_{TITLE|}" rows="10" name="new">{CONTENTS*}</textarea>
				</div>

				<div class="buttons_group">
					<input data-disable-on-click="1" class="button_screen_item buttons__save js-hover-disable-textarea-size-change {+START,IF,{$HAS_PRIVILEGE,comcode_dangerous}}js-click-headless-submit{+END}" type="submit" value="{!SAVE}" />
				</div>
			</form>
		</div>
	</section>
</div>
