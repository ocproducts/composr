
function mobile_menu_button(id) {
	var branch = document.getElementById('r_' + id + '_d');

	if (branch) {
		$cms.dom.toggle(branch.parentElement);
		return false;
	}

	return true;
}