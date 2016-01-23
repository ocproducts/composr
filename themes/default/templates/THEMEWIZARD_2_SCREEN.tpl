{TITLE}

<div class="float_surrounder">
	<div class="theme_wizard_info_box">
		<div class="box box___themewizard_2_screen"><div class="box_inner">
			<h2>{!SEED_COLOUR}</h2>

			<div>#<span class="theme_wizard_info_box_label">{SEED*}</span></div>
			<div>({!RED}: <span class="theme_wizard_colour">{RED*}</span>, {!GREEN}: <span class="theme_wizard_colour">{GREEN*}</span>, {!BLUE}: <span class="theme_wizard_colour">{BLUE*}</span>)</div>
			<div><span class="theme_wizard_change_colour horiz_field_sep associated_link"><a href="{CHANGE_URL*}">{!CHANGE}</a></span></div>
		</div></div>
	</div>

	<p>{!THEMEWIZARD_2_DOMINANT,{DOMINANT*}}</p>

	<p>{!THEMEWIZARD_2_LIGHT_DARK,{LD*}}</p>
</div>

{+START,IF,{$NOT,{$VALUE_OPTION,xhtml_strict}}}
	<div class="theme_wizard_preview_wrap">
		<div class="box box___themewizard_2_screen"><div class="box_inner">
			<h2>{!PREVIEW}</h2>

			<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!PREVIEW}" class="theme_wizard_preview" src="{$PAGE_LINK*,::keep_theme_seed={SEED#}:keep_theme_dark={DARK#}:keep_theme_source={SOURCE_THEME#}:keep_theme={SOURCE_THEME#}:keep_theme_algorithm={ALGORITHM#}:wide=1:keep_theme=default}">{!PREVIEW}</iframe>
		</div></div>
	</div>
{+END}

<nav>
	<ul class="actions_list">
		<li class="actions_list_strong"><a href="{STAGE3_URL*}">{!THEMEWIZARD_2_USE}</a></li>

		<li><a target="_blank" title="{!PREVIEW} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,::keep_theme_seed={SEED#}:keep_theme_dark={DARK#}:keep_theme_source={SOURCE_THEME#}:keep_theme={SOURCE_THEME#}:keep_theme_algorithm={ALGORITHM#}}">{!PREVIEW}</a></li>
	</ul>
</nav>
