{$REQUIRE_JAVASCRIPT,page_management}

{$SET,edit_zone_url,{$PAGE_LINK,_SEARCH:admin_zones:_edit:!}};
{$SET,add_zone_url,{$PAGE_LINK,_SEARCH:admin_zones:add}};
{$SET,zone_editor_url,{$PAGE_LINK,_SEARCH:admin_zones:_editor:!}};
{$SET,permission_tree_editor_url,{$PAGE_LINK,_SEARCH:admin_permissions:browse:!}};
{$SET,edit_page_url,{$PAGE_LINK,cms:cms_comcode_pages:_edit:page_link=!}};
{$SET,add_page_url,{$PAGE_LINK,_SEARCH:cms_comcode_pages:_edit:page_link=!:example}};
{$SET,delete_url,{$PAGE_LINK,_SELF:_SELF:delete:zone=[1]:page__[2]=1}};
{$SET,stats_url,{+START,IF,{$ADDON_INSTALLED,stats}}{$PAGE_LINK,_SEARCH:admin_stats:_page:iscreen=!}{+END}};
<div data-tpl="sitemapEditorScreen" data-tpl-params="{+START,PARAMS_JSON,edit_zone_url,add_zone_url,zone_editor_url,permission_tree_editor_url,edit_page_url,add_page_url,delete_url,stats_url}{_*}{+END}">
	{TITLE}

	<div class="float-surrounder">
		<div class="sitemap_right">
			<div class="box box___sitemap_editor_screen"><div class="box-inner">
				<h2>{!SELECTION_DETAILS}</h2>

				<div id="details_target">
					{!NO_ENTRY_POINT_SELECTED}
				</div>
			</div></div>
		</div>

		<div class="sitemap_left">
			<div class="box box___sitemap_editor_screen"><div class="box-inner">
				<h2>{!SITEMAP}</h2>

				<div class="accessibility-hidden"><label for="tree_list">{!ENTRY}</label></div>
				<form title="{!PRIMARY_PAGE_FORM}" action="index.php" method="post" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<input style="display: none" type="text" id="tree_list" name="tree_list" value="{$_GET*,id}" class="js-change-update-details-box" />
					<div id="tree_list__root_tree_list" class="sitemap_editor">
						<!-- List put in here -->
					</div>
				</form>
			</div></div>
		</div>
	</div>

	{+START,IF,{$ADDON_INSTALLED,redirects_editor}}
		<p>
			{!PAGE_DRAG,{$PAGE_LINK*,_SEARCH:admin_redirects}}
		</p>
	{+END}
</div>
