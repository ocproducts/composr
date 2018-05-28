<div class="generate-svg-sprite-screen">
	{TITLE}

	<h3>{!GENERATING_SPRITE*,{SPRITE_PATH}}</h3>

	<ul>
		{+START,LOOP,ICONS_ADDED}
			<li>{!ADDED_ICON*,{_loop_var}}</li>
		{+END}
	</ul>
</div>
