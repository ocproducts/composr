{TITLE}

<div class="float-surrounder">
	<div class="themewizard_info_box">
		<div class="box box___themewizard_2_screen"><div class="box_inner">
			<h2>{!SEED_COLOUR}</h2>

			<div>#<span class="themewizard_info_box_label">{SEED*}</span></div>
			<div>({!RED}: <span class="themewizard_colour">{RED*}</span>, {!GREEN}: <span class="themewizard_colour">{GREEN*}</span>, {!BLUE}: <span class="themewizard_colour">{BLUE*}</span>)</div>
			<div><span class="themewizard_change_colour horiz-field-sep associated-link"><a href="{CHANGE_URL*}">{!CHANGE}</a></span></div>
		</div></div>
	</div>

	<p>{!THEMEWIZARD_2_DOMINANT,{DOMINANT*}}</p>

	<p>{!THEMEWIZARD_2_LIGHT_DARK,{LD*}}</p>
</div>

<div class="themewizard_preview_wrap">
	<div class="box box___themewizard_2_screen"><div class="box_inner">
		<h2>{!PREVIEW}</h2>

		<iframe {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!PREVIEW}" class="themewizard_preview" src="{$PAGE_LINK*,::keep_theme_seed={SEED#}:keep_theme_dark={DARK#}:keep_theme_source={SOURCE_THEME#}:keep_theme={SOURCE_THEME#}:keep_theme_algorithm={ALGORITHM#}:wide=1:keep_theme=default}">{!PREVIEW}</iframe>
	</div></div>
</div>

<nav>
	<ul class="actions-list">
		<li class="actions_list_strong"><a href="{STAGE3_URL*}">{!THEMEWIZARD_2_USE}</a></li>

		<li><a target="_blank" title="{!PREVIEW} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,::keep_theme_seed={SEED#}:keep_theme_dark={DARK#}:keep_theme_source={SOURCE_THEME#}:keep_theme={SOURCE_THEME#}:keep_theme_algorithm={ALGORITHM#}}">{!PREVIEW}</a></li>
	</ul>
</nav>
