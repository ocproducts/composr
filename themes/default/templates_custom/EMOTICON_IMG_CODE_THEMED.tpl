{$SET,rndx,{$RAND}}

{+START,IF,{$NOT,{$IS_IN_GROUP,{$CONFIG_OPTION,jestr_emoticon_magnet_shown_for}}}}
	<img alt="{EMOTICON*}" src="{$IMG*,{SRC},1}" />
{+END}
{+START,IF,{$IS_IN_GROUP,{$CONFIG_OPTION,jestr_emoticon_magnet_shown_for}}}
	{$REQUIRE_JAVASCRIPT,core_rich_media}
	<div id="emoticoncrazy{$GET%,rndx}"></div>
	<script>// <![CDATA[
		$(function() {
			if (typeof window.crazy_criters=='undefined')
			{
				window.crazy_criters=[];
				window.setInterval(crazy_tick,300);
			}

			var my_id=parseInt(Math.random()*10000),emoticoncrazy=document.getElementById('emoticoncrazy{$GET%,rndx}');
			Composr.dom.html(emoticoncrazy,'<img id="'+my_id+'" style="position: relative" alt="{!EMOTICON;}" src="{$IMG*,{SRC},1}" />');
			crazy_criters.push(my_id);
		});
	//]]></script>
	<noscript>
		<img class="inline_image" alt="{EMOTICON*}" src="{$IMG*,{SRC},1}" />
	</noscript>
{+END}
