{$REQUIRE_JAVASCRIPT,tag_cloud}
<section class="box box___block_side_tag_cloud" data-require-javascript="tag_cloud" data-tpl="blockSideTagCloud"><div class="box_inner">
	<h3>{TITLE*}</h3>

	<nav id="tag_sphere" style="height: 150px; position:relative; overflow: hidden;">
		<ul style="margin:0;padding:0;list-style-type:none">
			{+START,LOOP,TAGS}
				<li id="item{_loop_key*}" style="margin:0;padding:0;list-style-type:none"><a rel="tag" href="{LINK*}" style="font-size: {EM*}em">{TAG*}</a></li>
			{+END}
		</ul>
	</nav>
</div></section>
