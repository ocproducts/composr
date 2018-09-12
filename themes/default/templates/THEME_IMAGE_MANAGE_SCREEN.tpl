{$REQUIRE_JAVASCRIPT,core_themeing}
<div data-tpl="themeImageManageScreen">
	{TITLE}

	<h2>{!EDIT}</h2>

	{FORM}

	<div class="box box---theme-image-manage-screen"><div class="box-inner">
		<h2>{!ADD} ({!ADVANCED})</h2>

		<p>{!ADDING_THEME_IMAGE}</p>

		<p class="buttons-group">
			<a class="btn btn-primary btn-scr admin--add" rel="add" href="{ADD_URL*}"><span>{+START,INCLUDE,ICON}NAME=admin/add{+END} {!ADD_THEME_IMAGE}</span></a>
		</p>
	</div></div>
</div>
