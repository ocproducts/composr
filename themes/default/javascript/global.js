/*{+START,INCLUDE,POLYFILL_FETCH,.js,javascript}{+END}*/

/*{+START,INCLUDE,POLYFILL_GENERAL,.js,javascript}{+END}*/

/*{+START,INCLUDE,POLYFILL_KEYBOARDEVENT_KEY,.js,javascript}{+END}*/

/*{+START,INCLUDE,POLYFILL_URL,.js,javascript}{+END}*/

/*{+START,INCLUDE,POLYFILL_WEB_ANIMATIONS,.js,javascript}{+END}*/

/*{+START,INCLUDE,JSON5,.js,javascript}{+END}*/

/*{+START,INCLUDE,UTIL,.js,javascript}{+END}*/

/*{+START,INCLUDE,DOM,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_FORM,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_UI,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_TEMPLATES,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_VIEWS,.js,javascript}{+END}*/

/*{+START,INCLUDE,CMS_BEHAVIORS,.js,javascript}{+END}*/

(function ($cms, $util, $dom) {
    'use strict';

    // Are we dealing with a touch device?
    document.documentElement.classList.toggle('is-touch-enabled', 'ontouchstart' in document.documentElement);

    // Is the document scrolled down?
    document.documentElement.classList.toggle('is-scrolled', window.scrollY > 0);

    window.addEventListener('scroll', function () {
        document.documentElement.classList.toggle('is-scrolled', window.scrollY > 0);
    });

    $dom.ready.then(function () {
        // Allow form submissions by removing this listener attached early in dom_init.js
        window.removeEventListener('submit', $dom.preventFormSubmissionUntilDomReadyListener, /*useCapture*/true);
        delete $dom.preventFormSubmissionUntilDomReadyListener;

        if ($cms.browserMatches('ie')) {
            /*{+START,SET,icons_sprite_url}{$IMG,icons{$?,{$THEME_OPTION,use_monochrome_icons},_monochrome}_sprite}{+END}*/
            loadSvgSprite('{$GET;,icons_sprite_url}');
        }

        // Start everything
        $cms.attachBehaviors(document);
    });

    /**
     * Workaround for IE not supporting external SVG with <use> elements.
     * Loads an SVG sprite using AJAX and appends its contents to the body.
     * Also looks for any <use> elements with external [xlink:href] attributes matching the sprite URL and replaces them with simple #IDs.
     * @param spriteUrl
     */
    function loadSvgSprite(spriteUrl) {
        spriteUrl = $util.url(spriteUrl);

        var xhr = new XMLHttpRequest();
        xhr.overrideMimeType('text/xml');
        xhr.open('GET', spriteUrl);
        xhr.onload = function () {
            var svg = xhr.responseXML && xhr.responseXML.querySelector('svg');

            if (!svg) {
                return;
            }

            var div = document.createElement('div');
            div.style.cssText = 'position: absolute; width: 0; height: 0; visibility: hidden; overflow: hidden;';
            div.appendChild(svg);
            (document.body || document.documentElement).appendChild(div);

            var uses = document.querySelectorAll('use');

            for (var i = 0; i < uses.length; i++) {
                var use = uses[i],
                    hrefParts = strVal(use.getAttribute('xlink:href')).split('#'),
                    hrefUrl = $util.url(hrefParts[0]),
                    hrefId = hrefParts[1];

                if (hrefUrl.toString() === spriteUrl.toString()) {
                    use.setAttribute('xlink:href', '#' + hrefId);
                }
            }
        };
        xhr.send();
    }
}(window.$cms, window.$util, window.$dom));
