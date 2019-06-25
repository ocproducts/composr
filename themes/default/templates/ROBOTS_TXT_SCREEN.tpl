<div data-require-javascript="robots_txt" data-view="RobotsTxtScreen">
	{TITLE}

	<form title="{!PRIMARY_PAGE_FORM}" action="{POST_URL*}" method="post" autocomplete="off" class="js-form-robots-txt">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			<label for="robots_txt" class="accessibility-hidden">{!TEXT}</label>
			<textarea name="robots_txt" id="robots_txt" cols="30" rows="15" class="wide-field">{TEXT*}</textarea>
		</div>

		<p class="proceed-button">
			<button class="button-screen buttons--save" id="submit-button" accesskey="u" type="submit">{+START,INCLUDE,ICON}NAME=buttons/save{+END} {!SAVE}</button>
		</p>

		<h2>{!DEFAULT}</h2>

		<div>
			<label for="robots_txt_default" class="accessibility-hidden">{!DEFAULT}</label>
			<textarea readonly="readonly" name="robots_txt_default" id="robots_txt_default" cols="30" rows="10" class="wide-field">{DEFAULT*}</textarea>
		</div>
	</form>
</div>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/ace/ace.js"></script>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/ace/ace_composr.js"></script>
