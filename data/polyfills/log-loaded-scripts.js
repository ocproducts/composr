(function ($cms) {
    'use strict';
    /*
     * Copyright 2012 The Polymer Authors. All rights reserved.
     * Use of this source code is governed by a BSD-style
     * license that can be found in the LICENSE file:
     * https://github.com/Polymer/WeakMap/blob/master/LICENSE
     */

    if (typeof window.WeakMap === 'undefined') {
        (function() {
            var defineProperty = Object.defineProperty;
            var counter = Date.now() % 1e9;

            function WeakMap() {
                this.name = '__st' + (Math.random() * 1e9 >>> 0) + (counter++ + '__');
            }

            WeakMap.polyfill = true;

            WeakMap.prototype = {
                set: function(key, value) {
                    var entry = key[this.name];
                    if (entry && entry[0] === key)
                        entry[1] = value;
                    else
                        defineProperty(key, this.name, {value: [key, value], writable: true});
                    return this;
                },
                get: function(key) {
                    var entry;
                    return (entry = key[this.name]) && entry[0] === key ?
                        entry[1] : undefined;
                },
                delete: function(key) {
                    var entry = key[this.name];
                    if (!entry) return false;
                    var hasValue = entry[0] === key;
                    entry[0] = entry[1] = undefined;
                    return hasValue;
                },
                has: function(key) {
                    var entry = key[this.name];
                    if (!entry) return false;
                    return entry[0] === key;
                }
            };

            window.WeakMap = WeakMap;
        })();
    }

    // Workaround for bug, document.readyState == 'interactive' before [defer]'d <script>s are loaded :(
    // https://github.com/jquery/jquery/issues/3271
    /**
     * @memberOf $cms
     * @type {boolean}
     */
    $cms.isDOMContentLoaded = Boolean($cms.isDOMContentLoaded);

    document.addEventListener('DOMContentLoaded', function() {
        $cms.isDOMContentLoaded = true;
    });

    /* Required for $cms.requireCss and $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular stylesheet/script has been already loaded */
    /**
     * @memberOf $cms
     * @type { WeakMap }
     */
    $cms.elementsLoaded = new WeakMap();
    
    document.addEventListener('load', listener, /*useCapture*/true);
    document.addEventListener('error', listener, /*useCapture*/true);
    
    function listener(event) {
        var loadedEl = event.target, 
            hasLoaded = (event.type === 'load');

        if (!loadedEl) {
            return;
        }
        
        $cms.elementsLoaded.set(loadedEl, hasLoaded);
    }
    
    window.addEventListener('click', function (e) {
        if (e.target && (e.target.localName === 'a') && (e.target.getAttribute('href') === '#!')) {
            //e.preventDefault();
        }
    }, /*useCapture*/true);

    window.addEventListener('submit', function (e) {
        if (e.target && (e.target.localName === 'form') && (e.target.getAttribute('action') === '#!')) {
            //e.preventDefault();
        }
    }, /*useCapture*/true);

}(window.$cms || (window.$cms = {})));
