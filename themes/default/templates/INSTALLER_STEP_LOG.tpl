<p>
	{!INSTALL_LOG_BELOW,{CURRENT_STEP*}}:
</p>

<div class="actions_list installer_main_min">
	<div class="install_log_table">
		<p class="lonely_label">{!INSTALL_LOG}:</p>
		<ul>
			{LOG}
		</ul>
	</div>
</div>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	<div>
		{HIDDEN}

		<p class="proceed_button">
			<input id="proceed_button" class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
		</p>
	</div>
</form>

<script {$CSP_NONCE_HTML}>
(function () {
    'use strict';
	/* Code to auto-submit the form after 5 seconds, but only if there were no errors */
	var doh = !!document.querySelector('.installer_warning');
	if (doh) {
	    return;
	}

	var button = document.getElementById('proceed_button');
	button.countdown = 6;
	var timer;
	var continueFunc = function continueFunc() {
		button.value = "{!PROCEED} ({!AUTO_IN} " + button.countdown + ")";
		if (button.countdown === 0) {
			if (timer) {
				window.clearInterval(timer);
			}
			timer = null;
			button.form.submit();
		} else {
			button.countdown--;
		}
	};
	continueFunc();
	timer = window.setInterval(continueFunc, 1000);
	button.addEventListener('mouseover', function () {
		if (timer) {
			window.clearInterval(timer);
		}
		timer = null;
	});
	window.addEventListener('unload', function () {
		if (timer) {
			window.clearInterval(timer);
		}
		timer = null;
	});
	button.addEventListener('mouseout', function () {
		timer = window.setInterval(continueFunc, 1000);
	});
}());
</script>
