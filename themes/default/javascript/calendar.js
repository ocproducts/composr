(function ($cms) {
    'use strict';

    $cms.templates.calendarEventType = function calendarEventType() {
        var container = this;

        $cms.dom.on(container, 'click', '.js-click-toggle-checkbox-event-type', function (e, el) {
            var checkbox = el.querySelector('.js-checkbox-event-type');

            if (e.target !== checkbox) {
                $cms.dom.toggleChecked(checkbox);
            }
        });
    };
}(window.$cms));