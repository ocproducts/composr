<!-- Elastislide Carousel -->
<ul class="elastislide-list">
	{+START,LOOP,TUTORIALS}
		<li>
			<a class="tutorial_tooltip" data-name="{NAME*}" href="{URL*}" style="position: relative"><img src="{ICON*}" alt="" /><span class="tutorial_label">{$TRUNCATE_LEFT,{TITLE},23}</span></a>
		</li>
	{+END}
</ul><!-- End Elastislide Carousel -->
