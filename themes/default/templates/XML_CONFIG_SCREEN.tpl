{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" action="{POST_URL*}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="constrain_field">
		<label for="xml" class="accessibility_hidden">XML</label>
		<textarea name="xml" id="xml" cols="30" rows="30" class="wide_field">{XML*}</textarea>
	</div>

	<p class="proceed_button">
		<input class="button_screen buttons__save" id="submit_button" accesskey="u" type="submit" value="{!SAVE}" />
	</p>
</form>

<script src="{$BASE_URL*}/data/ace/ace.js"></script>
<script src="{$BASE_URL*}/data/ace/ace_composr.js"></script>
<script>// <![CDATA[
	ace_composr_loader('xml','xml');
//]]></script>
