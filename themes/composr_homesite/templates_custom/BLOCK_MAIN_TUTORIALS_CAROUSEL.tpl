{$SET,rand_id,rand_{$RAND}}

<!-- Elastislide Carousel -->
<ul id="{$GET*,rand_id}" class="elastislide-list">
	{+START,LOOP,TUTORIALS}
		<li>
			<a class="tutorial_tooltip" data-name="{NAME*}" href="{URL*}" style="position: relative"><img width="130" height="130" src="{$THUMBNAIL*,{ICON},130x130,,,,pad,both,#FFFFFF}" alt="" /><span class="tutorial_label">{$TRUNCATE_LEFT,{TITLE},23}</span></a>
		</li>
	{+END}
</ul><!-- End Elastislide Carousel -->

<script>//<![CDATA[
	$(document).ready(function() {
		$('#{$GET%,rand_id}').elastislide();

		// Tutorial boxes...

		var tutorials=get_elements_by_class_name(document.getElementById('{$GET%,rand_id}'),'tutorial_tooltip');
		for (var i=0;i<tutorials.length;i++)
		{
			apply_tutorial_tooltip(tutorials[i]);
		}
	});
//]]></script>
