<form title="{!JUMP} ({!FORM_AUTO_SUBMITS})" method="get" action="{$FIND_SCRIPT*,netlink}" autocomplete="off">
	<div>
		<div>
			<p class="accessibility-hidden"><label for="netlink-url">{!JUMP}</label></p>
			<select data-change-submit-form="1" id="netlink-url" name="url" class="form-control form-control-wide">
				{CONTENT}
			</select>
		</div>
	</div>
</form>
