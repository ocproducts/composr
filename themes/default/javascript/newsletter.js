(function ($cms) {
    'use strict';

    $cms.templates.newsletterPreview = function (params) {
        var frame_id = 'preview_frame',
            html = $cms.strval(params.htmlPreview);

        window.setTimeout(function () {
            var adjusted_preview = html.replace(/<!DOCTYPE[^>]*>/i, '').replace(/<html[^>]*>/i, '').replace(/<\/html>/i, '');
            var de = window.frames[frame_id].document.documentElement;
            var body = de.querySelector('body');
            if (!body) {
                $cms.dom.html(de, adjusted_preview);
            } else {
                var head_element = de.querySelector('head');
                if (!head_element) {
                    head_element = document.createElement('head');
                    de.appendChild(head_element);
                }
                if (!de.querySelector('style') && adjusted_preview.indexOf('<head') != -1) {/*{$,The conditional is needed for Firefox - for some odd reason it is unable to parse any head tags twice}*/
                    $cms.dom.html(head_element, adjusted_preview.replace(/^(.|\n)*<head[^>]*>((.|\n)*)<\/head>(.|\n)*$/i, '$2'));
                }

                $cms.dom.html(body, adjusted_preview.replace(/^(.|\n)*<body[^>]*>((.|\n)*)<\/body>(.|\n)*$/i, '$2'));
            }

            resize_frame(frame_id, 300);
        }, 500);

        window.setInterval(function () {
            resize_frame(frame_id, 300);
        }, 1000);
    }

}(window.$cms));

