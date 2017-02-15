{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_ui}
{$REQUIRE_JAVASCRIPT,jquery_flip}
{$REQUIRE_CSS,flip}

{$SET,RAND_FLIP,{$RAND}}

<div class="flipbox" id="flipbox_{$GET%,RAND_FLIP}">
	{$COMCODE,{PARAM}}
</div>

<script>// <![CDATA[
$cms.ready.then(function() {
    var _el = document.getElementById("flipbox_{$GET%,RAND_FLIP}");

    _el.onclick = function () {
        var el = $("#flipbox_{$GET%,RAND_FLIP}");

        if (_el.flipped === undefined) {
            _el.flipped = false;
        }
        if (_el.flipped) {
            el.revertFlip();
        } else {
            el.flip({
                color: '{+START,IF,{$NOT,{$IN_STR,{FINAL_COLOR},#}}}#{+END}{FINAL_COLOR;^/}',
                speed: +'{SPEED%}',
                direction: 'tb',
                content: '{CONTENT;^/}'
            })
        }
        _el.flipped = !_el.flipped;
    }
});
//]]></script>
