<!-- Required for $cms.requireJavascript() to work properly as DOM does not currently provide any way to check if a particular script has been already loaded -->
<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/log-loaded-scripts.js"></script>

{$,Load classList and ES6 Promise polyfill for Internet Explorer LEGACY}
{+START,IF,{$BROWSER_MATCHES,ie}}
<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/class-list.js"></script>
<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/promise.js"></script>
<script {$CSP_NONCE_HTML} src="{$BASE_URL*}/data/polyfills/custom-event-constructor.js"></script>
{+END}

{$,Polyfills for everyone LEGACY}
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/general.js"></script>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/url.js"></script>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/keyboardevent-key-polyfill.js"></script>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/fetch.js"></script>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/web-animations.min.js"></script>
<script {$CSP_NONCE_HTML} defer="defer" src="{$BASE_URL*}/data/polyfills/json5.js"></script>
