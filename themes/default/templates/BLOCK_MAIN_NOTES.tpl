{$REQUIRE_JAVASCRIPT,ajax}
{$REQUIRE_JAVASCRIPT,checking}
<div class="form_ajax_target" data-view="BlockMainNotes" data-view-params="{+START,PARAMS_JSON,BLOCK_NAME,MAP}{_*}{+END}">
	<section id="tray_{TITLE|}" data-view="ToggleableTray" data-tray-cookie="{TITLE|}" class="box box___block_main_notes">
		<h3 class="toggleable_tray_title js-tray-header">
			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{TITLE}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

			{+START,IF_NON_EMPTY,{TITLE}}
				<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{TITLE*}</a>
			{+END}
		</h3>

		<div class="toggleable_tray js-tray-content">
			<form title="{$STRIP_TAGS,{TITLE}}" method="post" action="{URL*}" autocomplete="off" class="js-form-block-main-notes">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="accessibility_hidden"><label for="n_block_{TITLE|}">{!NOTES}</label></div>
				<div class="constrain_field">
					<textarea onfocus="this.setAttribute('rows','23');" onblur="if (!this.form.disable_size_change) this.setAttribute('rows','10');" class="wide_field" cols="80" id="n_block_{TITLE|}" rows="10" name="new" {+START,IF,{SCROLLS}}wrap="off"{+END}>{CONTENTS*}</textarea>
				</div>

				<div class="buttons_group">
					<input data-disable-on-click="1" class="button_screen_item buttons__save {+START,IF,{$HAS_PRIVILEGE,comcode_dangerous}}js-click-headless-submit{+END}" type="submit" onmouseover="this.form.disable_size_change=true;" onmouseout="this.form.disable_size_change=false;" value="{!SAVE}" />
				</div>
			</form>
		</div>
	</section>
</div>
