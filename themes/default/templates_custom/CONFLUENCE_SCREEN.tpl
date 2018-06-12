<div class="clearfix">
	<div class="confluence-left">
		{$SET,confluence_menu,{$?,{$CONFIG_OPTION,single_public_zone},,site}:docs:{ROOT_ID}}

		{$BLOCK,block=menu,param={$GET,confluence_menu},type=popup}
	</div>

	<div class="confluence-main">
		<div class="clearfix">
			{HTML}
		</div>
	</div>
</div>
