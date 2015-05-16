{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_ui_core}
{$REQUIRE_JAVASCRIPT,jquery_flip}
{$REQUIRE_CSS,flip}

{$SET,RAND,{$RAND}}

<div class="flipbox" id="flipbox_{$GET,RAND}">
	{$COMCODE,{PARAM}}
</div>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		var _e=document.getElementById("flipbox_{$GET,RAND}");
		_e.onclick=function() {
			var e=$("#flipbox_{$GET,RAND}");
			if (typeof _e.flipped=='undefined') _e.flipped=false;
			if (_e.flipped)
			{
				e.revertFlip();
			} else
			{
				e.flip({
					color:'{+START,IF,{$NOT,{$IN_STR,{FINAL_COLOR},#}}}#{+END}{FINAL_COLOR;^/}',
					speed:{SPEED%},
					direction:'tb',
					content:'{CONTENT;^/}'
				})
			};
			_e.flipped=!_e.flipped;
		}
	});
//]]></script>
