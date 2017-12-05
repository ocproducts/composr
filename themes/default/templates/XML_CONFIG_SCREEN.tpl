{$REQUIRE_JAVASCRIPT,core_configuration}

<div data-require-javascript="core_configuration" data-view="XmlConfigScreen">
	{TITLE}

	<form title="{!PRIMARY_PAGE_FORM}" action="{POST_URL*}" method="post" autocomplete="off" class="js-form-xml-config">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			<label for="xml" class="accessibility_hidden">XML</label>
			<textarea name="xml" id="xml" cols="30" rows="30" class="wide_field">{XML*}</textarea>
		</div>

		<p class="proceed_button">
			<input class="button_screen buttons--save" id="submit_button" accesskey="u" type="submit" value="{!SAVE}" />
		</p>
	</form>
</div>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/ace/ace.js"></script>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/ace/ace_composr.js"></script>
