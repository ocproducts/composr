(function ($, Composr) {
    Composr.behaviors.coreNotificatonsManageScreen = {
        attach: function (context) {
            var soundRadioEl = document.getElementById('sound_' + read_cookie('sound', 'off'));

            if (soundRadioEl) {
                soundRadioEl.checked = true;
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);