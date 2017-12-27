{TITLE}

{+START,IF_NON_EMPTY,{ROWS}}
	<div class="wide-table-wrap"><table class="columned_table wide-table results-table responsive-table">
		<thead>
			<tr>
				<th><a href="{$PAGE_LINK*,_SELF:admin_cmsusers:users:sortby=name{NAMEORD}}">{!CMS_WEBSITE_NAME}</a></th>
				<th><a href="{$PAGE_LINK*,_SELF:admin_cmsusers:users:sortby=acp{ACPORD}}">{!CMS_LAST_ADMIN_ACCESS}</a></th>
				<th>{!CMS_STILL_INSTALLED}</th>
				<th><a href="{$PAGE_LINK*,_SELF:admin_cmsusers:users:sortby=version{VERORD}}">{!VERSION}</a></th>
				<th>{!CMS_PRIVACY}</th>
			</tr>
		</thead>

		<thead>
			{ROWS}
		</thead>
	</table></div>
{+END}

{+START,IF_EMPTY,{ROWS}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}
