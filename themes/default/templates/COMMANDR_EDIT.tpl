{$SET,rndx,{$RAND}}
{$REQUIRE_JAVASCRIPT,commandr}

<div data-tpl="commandrEdit" data-tpl-params="{+START,PARAMS_JSON,FILE}{_*}{+END}">
	<form title="{!EDIT}" action="{SUBMIT_URL*}" class="js-submit-commandr-form-submission" data-submit-pd="1" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			<p class="lonely_label"><label for="edit_content{$GET%,rndx}">{!EDIT}:</label></p>
			<div class="constrain_field"><textarea class="wide_field textarea_scroll" cols="60" rows="10" id="edit_content{$GET%,rndx}" name="edit_content">{FILE_CONTENTS*}</textarea></div>

			<p>
				<input class="button_screen_item buttons__proceed" type="submit" value="{!PROCEED}" />
			</p>
		</div>
	</form>
</div>
