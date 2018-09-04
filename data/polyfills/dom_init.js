(function ($dom) {
    'use strict';

    /**
     * @memberof $dom
     * @type { Promise }
     */
    $dom.init = new Promise(function (resolve) {
        $dom._resolveInit = resolve;
    });
    
    /**
     * @memberof $dom
     * @type { Promise }
     */
    $dom.ready = new Promise(function (resolve) {
        $dom._resolveReady = resolve;
    });

    /**
     * @memberof $dom
     * @type { Promise }
     */
    $dom.load = new Promise(function (resolve) {
        $dom._resolveLoad = resolve;
    });
    
    /**
     * Required for $cms.requireCss and $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular element has been already loaded
     * @memberof $dom
     * @type { WeakMap }
     */
    $dom.elementsLoaded = new WeakMap();
    
    document.addEventListener('load', resourceLoadListener, /*useCapture*/true);
    document.addEventListener('error', resourceLoadListener, /*useCapture*/true);
    
    function resourceLoadListener(event) {
        var loadedEl = event.target, 
            hasLoaded = (event.type === 'load');

        if (!loadedEl) {
            return;
        }

        $dom.elementsLoaded.set(loadedEl, hasLoaded);
    }

    // Prevent url change for clicks on anchor tags with a placeholder href
    window.addEventListener('click', function (e) {
        var anchor = e.target;
        
        // A child elemenet within an <a> element might've been clicked
        while ((anchor.localName !== 'a') && anchor.parentElement) {
            anchor = anchor.parentElement;
        }
        
        if ((anchor.localName === 'a') && (anchor.getAttribute('href') === '#!')) {
            e.preventDefault();
        }
    }, /*useCapture*/true);

    // Prevent form submission for forms with a placeholder action
    window.addEventListener('submit', function (e) {
        var form = e.target;
        
        if (form.getAttribute('action') === '#!') {
            e.preventDefault();
        }
    }, /*useCapture*/true);
    
    // Prevent form submission until the DOM is ready
    $dom.preventFormSubmissionUntilDomReadyListener = function preventFormSubmissionUntilDomReadyListener(e) {
        e.preventDefault();
        window.alert('Please wait for the page to load then try again.');
    };

    window.addEventListener('submit', $dom.preventFormSubmissionUntilDomReadyListener, /*useCapture*/true);
    
    window.addEventListener('load', function () {
        if ($dom.preventFormSubmissionUntilDomReadyListener !== undefined) {
            // Should have been removed on DOM ready, something is wrong.
            window.alert('Error: Looks like important JavaScript files failed to load. Reload the page or see console for debug info.');
        }
    });

}(window.$dom || (window.$dom = {})));
