<!DOCTYPE html>

<html lang="{$LCASE*,{$LANG}}" dir="{!dir}">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset={$CHARSET*}" />
		<meta name="GENERATOR" content="Composr" />
		<meta name="description" content="Composr installer" />
		<link rel="icon" href="{$BRAND_BASE_URL*}/favicon.ico" type="image/x-icon" />
		<link href="{CSS_URL*}" rel="stylesheet" />
		<link href="{CSS_URL_2*}" rel="stylesheet" />
		<style>
			{CSS_NOCACHE*}
		</style>
		<title>{!INSTALLER,Composr}</title>

		<meta name="robots" content="noindex, nofollow" />
		<script {$CSP_NONCE_HTML} src="{$BASE_URL}/data/polyfills/log-loaded-scripts.js"></script>
		<script {$CSP_NONCE_HTML}>
			window.IN_MINIKERNEL_VERSION = true;

			function installStageLoad() {
				//set_cookie('js_on',1,120);

				var none = document.getElementById('{DEFAULT_FORUM;/}');
				if (none) none.checked = true;

				if (('{DEFAULT_FORUM;/}' != 'none') && ('{DEFAULT_FORUM;/}' != 'cns')) {
					var d = document.getElementById('forum_path');
					if (d) d.style.display = 'block';
				}

				var forms = document.getElementsByTagName('form');
				if (typeof forms[0] != 'undefined') forms[0].title = '';

				var cns = document.getElementById('cns');
				if (cns) {
					var useMultiDbLocker = function() {
						forms[0].elements['use_multi_db'][0].disabled = cns.checked;
						forms[0].elements['use_multi_db'][1].disabled = cns.checked;
						if (cns.checked) {
							forms[0].elements['use_multi_db'][1].checked = true;
						}
					};
					for (var i=0; i < forms[0].elements['forum'].length; i++) {
						forms[0].elements['forum'][i].onclick = useMultiDbLocker;
					}
					useMultiDbLocker();
				}
			}

			function set_cookie(cookieName, cookieValue, expiryDays) {
				var today = new Date(),
					expires = new Date();

				expiryDays = +expiryDays || 1;

				expires.setTime(today.getTime() + 3600000 * 24 * expiryDays);

				document.cookie = cookieName + "=" + escape(cookieValue) + ";expires=" + expires.toUTCString();
			}

			function do_forum_choose(object, versions) {
				$cms.dom.html(document.getElementById('versions'), versions);

				var type = 'none';
				if ((object.id !== 'none') && (object.id !== 'cns')) {
					type = 'block';
					var label = document.getElementById('sep_forum');
					if (label) {
						$cms.dom.html(label, object.nextSibling.nodeValue);
					}
				}

				document.getElementById('forum_database_info').style.display = type;
				if (document.getElementById('forum_path')) {
					document.getElementById('forum_path').style.display = type;
				}
			}

			function toggle_section(id) {
				// Try and grab our item
				var itm = document.getElementById(id),
					img = document.getElementById('img_' + id);

				if (itm.style.display === 'none') {
					itm.style.display = 'block';
					if (img) {
						img.src = '{$BASE_URL;/}/install.php?type=contract';
						img.alt = img.alt.replace('{!EXPAND;}', '{!CONTRACT;}');
						img.title = img.title.replace('{!EXPAND;}', '{!CONTRACT;}');
					}
				} else {
					itm.style.display = 'none';
					if (img) {
						img.src = '{$BASE_URL;/}/install.php?type=expand';
						img.alt = img.alt.replace('{!CONTRACT;}', '{!EXPAND;}');
						img.title = img.title.replace('{!CONTRACT;}', '{!EXPAND;}');
					}
				}
			}
		</script>

		{+START,INCLUDE,PASSWORD_CHECK_JS}INSTALLER=1{+END}
	</head>

	<body id="installer_body" class="website_body" onload="installStageLoad();">
		<div class="installer_main">
			<img alt="Composr" src="{LOGO_URL*}" width="550" height="115" />
		</div>

		<div class="installer_main_inner">
			<div class="box box___installer_html_wrap"><div class="box_inner">
				<h1>{!INSTALLER,Composr}: {!INSTALLER_STEP,{STEP},10}</h1>

				<div id="extra_errors"></div>

				<div>
					{CONTENT}
				</div>
			</div></div>
		</div>

		<div class="installer_version">
			<p>
				{!VERSION_NUM,{VERSION}}
				<br />
				Composr, {!CREATED_BY,ocProducts}
			</p>
			<p>
				<a target="_blank" title="compo.sr {!LINK_NEW_WINDOW}" href="{$BRAND_BASE_URL*}">{$BRAND_BASE_URL*}</a>
			</p>
		</div>

		<script {$CSP_NONCE_HTML}>
			(function (){
				'use strict';

				var step4Form = document.getElementById('form-installer-step-4');

				if (step4Form) {
					step4Form.addEventListener('submit', validateSettings);
				}

				function validateSettings(e) {
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
						if ((step4Form.elements[i].className.indexOf('required1') !== -1) && (step4Form.elements[i].value === '')) {
							window.alert('{!IMPROPERLY_FILLED_IN;/}');
							return false;
						}
					}

					if (!checkPasswords(step4Form)) {
						return false;
					}

					e.preventDefault();

					var checkPromises = [];

					if ((step4Form.elements['db_site_password'])) {
						var sitePwdCheckUrl = 'install.php?type=ajax_db_details';
						var post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_site_host=' + encodeURIComponent(step4Form.elements['db_site_host'].value) + '&db_site=' + encodeURIComponent(step4Form.elements['db_site'].value) + '&db_site_user=' + encodeURIComponent(step4Form.elements['db_site_user'].value) + '&db_site_password=' + encodeURIComponent(step4Form.elements['db_site_password'].value);
						checkPromises.push($cms.form.doAjaxFieldTest(sitePwdCheckUrl, post));
					}

					if (step4Form.elements['db_forums_password']) {
						var forumsPwdCheckUrl = 'install.php?type=ajax_db_details';
						var post = 'db_type=' + encodeURIComponent(step4Form.elements['db_type'].value) + '&db_forums_host=' + encodeURIComponent(step4Form.elements['db_forums_host'].value) + '&db_forums=' + encodeURIComponent(step4Form.elements['db_forums'].value) + '&db_forums_user=' + encodeURIComponent(step4Form.elements['db_forums_user'].value) + '&db_forums_password=' + encodeURIComponent(step4Form.elements['db_forums_password'].value);
						checkPromises.push($cms.form.doAjaxFieldTest(forumsPwdCheckUrl, post));
					}

					if (step4Form.elements['ftp_domain']) {
						var ftpDomainCheckUrl = 'install.php?type=ajax_ftp_details';
						var post = 'ftp_domain=' + encodeURIComponent(step4Form.elements['ftp_domain'].value) + '&ftp_folder=' + encodeURIComponent(step4Form.elements['ftp_folder'].value) + '&ftp_username=' + encodeURIComponent(step4Form.elements['ftp_username'].value) + '&ftp_password=' + encodeURIComponent(step4Form.elements['ftp_password'].value);
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
	</body>
</html>
