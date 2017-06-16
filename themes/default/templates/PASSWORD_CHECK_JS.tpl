<script>
function checkPasswords(form) {
	if (form.confirm) {
		return true;
	}

	if (form.elements['cns_admin_password_confirm'] !== undefined) {
		if (!checkPassword(form, 'cns_admin_password', '{!ADMIN_USERS_PASSWORD;^/}')) {
			return false;
		}
	}

	if (form.elements['master_password_confirm'] !== undefined) {
		if (!checkPassword(form, 'master_password', '{!MASTER_PASSWORD;^/}')) {
			return false;
		}
	}

	if ('{PASSWORD_PROMPT;/}' !== '') {
		window.alert('{PASSWORD_PROMPT;/}');
	}

	return true;


	function checkPassword(form, field_name, field_label) {
		// Check matches with confirm field
		if (form.elements[field_name + '_confirm'].value != form.elements[field_name].value) {
			window.alert('{!PASSWORDS_DO_NOT_MATCH;^/}'.replace('\{1\}', field_label));
			return false;
		}

		// Check does not match database password
		if (form.elements['db_site_password'] != null) {
			if ((form.elements[field_name].value != '') && (form.elements[field_name].value == form.elements['db_site_password'].value)) {
				window.alert('{!PASSWORDS_DO_NOT_REUSE;^/}'.replace('\{1\}', field_label));
				return false;
			}
		}

		// Check password is secure
		var isSecurePassword = true;
		if (form.elements[field_name].value.length < 8) isSecurePassword = false;
		if (!form.elements[field_name].value.match(/[a-z]/)) isSecurePassword = false;
		if (!form.elements[field_name].value.match(/[A-Z]/)) isSecurePassword = false;
		if (!form.elements[field_name].value.match(/\d/)) isSecurePassword = false;
		if (!form.elements[field_name].value.match(/[^a-zA-Z\d]/)) isSecurePassword = false;
		if (!isSecurePassword) {
			return window.confirm('{!PASSWORD_INSECURE;^/}'.replace('\{1\}', field_label)) && window.confirm('{!CONFIRM_REALLY;^/} {!PASSWORD_INSECURE;^/}'.replace('\{1\}', field_label));
		}

		return true;
	}
}
</script>
