<form id="form-installer-step-4" title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{HIDDEN}

	<div>
		<div class="installer_main_min">
			{MESSAGE}

			{SECTIONS}
		</div>

		<p class="proceed_button">
			<input class="button_screen buttons__proceed" type="submit" value="{!INSTALL} Composr" />
		</p>
	</div>
</form>

{+START,IF_PASSED,JS}
<script {$CSP_NONCE_HTML}>
		{JS/}

	(function (){
		'use strict';
		
		var domain = document.getElementById('domain');
		if (domain) {
			domain.onchange = function () {
				var cs = document.getElementById('Cookie_space_settings');
				if (cs && (cs.style.display === 'none')) {
					toggleSection('Cookie_space_settings');
				}
				var cd = document.getElementById('cookie_domain');
				if (cd && (cd.value !== '')) {
					cd.value = '.' + domain.value;
				}
			}
		}

		var step4Form = document.getElementById('form-installer-step-4');

		if (step4Form) {
			step4Form.addEventListener('submit', validateSettings);
		}

		function validateSettings(e) {
			e.preventDefault();
		    
			if ((step4Form.elements['forum_base_url']) && (step4Form.elements['forum_base_url'].type !== 'hidden') && (step4Form.elements['forum_base_url'].value === step4Form.elements['base_url'].value)) {
				window.alert('{!FORUM_BASE_URL_INVALID;/}');
				return false;
			}

			if ((step4Form.elements['forum_base_url']) && (step4Form.elements['forum_base_url'].type !== 'hidden') && (step4Form.elements['forum_base_url'].value.substr(-7) === '/forums') && (!step4Form.elements['forum_base_url'].changed)) {
				if (!window.confirm('{!FORUM_BASE_URL_UNCHANGED;/}')) {
					return false;
				}
			}

			for (var i = 0; i < step4Form.elements.length; i++) {
				if ((step4Form.elements[i].classList.contains('required1')) && (step4Form.elements[i].value === '')) {
					window.alert('{!IMPROPERLY_FILLED_IN;/}');
					return false;
				}
			}

			if (!checkPasswords(step4Form)) {
				return false;
			}

			var checkPromises = [], post;

			if ((step4Form.elements['db_site_password'])) {
				var sitePwdCheckUrl = 'install.php?type=ajax_db_details';
				post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_site_host=' + encodeURIComponent(step4Form.elements['db_site_host'].value) + '&db_site=' + encodeURIComponent(step4Form.elements['db_site'].value) + '&db_site_user=' + encodeURIComponent(step4Form.elements['db_site_user'].value) + '&db_site_password=' + encodeURIComponent(step4Form.elements['db_site_password'].value);
				checkPromises.push($cms.form.doAjaxFieldTest(sitePwdCheckUrl, post));
			}

			if (step4Form.elements['db_forums_password']) {
				var forumsPwdCheckUrl = 'install.php?type=ajax_db_details';
				post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_forums_host=' + encodeURIComponent(step4Form.elements['db_forums_host'].value) + '&db_forums=' + encodeURIComponent(step4Form.elements['db_forums'].value) + '&db_forums_user=' + encodeURIComponent(step4Form.elements['db_forums_user'].value) + '&db_forums_password=' + encodeURIComponent(step4Form.elements['db_forums_password'].value);
				checkPromises.push($cms.form.doAjaxFieldTest(forumsPwdCheckUrl, post));
			}

			if (step4Form.elements['ftp_domain']) {
				var ftpDomainCheckUrl = 'install.php?type=ajax_ftp_details';
				post = 'ftp_domain=' + encodeURIComponent(step4Form.elements['ftp_domain'].value) + '&ftp_folder=' + encodeURIComponent(step4Form.elements['ftp_folder'].value) + '&ftp_username=' + encodeURIComponent(step4Form.elements['ftp_username'].value) + '&ftp_password=' + encodeURIComponent(step4Form.elements['ftp_password'].value);
				checkPromises.push($cms.form.doAjaxFieldTest(ftpDomainCheckUrl, post));
			}

			Promise.all(checkPromises).then(function (validities) {
				if (!validities.includes(false)) {
					// All valid!
					step4Form.removeEventListener('submit', validateSettings);
					step4Form.submit();
				}
			});
		}
	}());
</script>
{+END}
