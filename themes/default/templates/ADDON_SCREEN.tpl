{TITLE}

<p>{!ADDONS_SCREEN}</p>

{+START,IF_NON_EMPTY,{ADDONS}}
	{+START,IF_NON_EMPTY,{UPDATED_ADDONS}}
		{$,Link repeated here and below because it is important}
		<ul role="navigation" class="actions_list spaced_list">
			<li>
				<a href="{$PAGE_LINK*,_SELF:_SELF:addon_import:to_import={UPDATED_ADDONS}}"><strong>{!IMPORT_UPDATED_ADDONS}</strong></a>
			</li>
		</ul>
	{+END}

	{+START,IF,{$JS_ON}}
		<div class="float_surrounder">
			<p class="right associated_link">
				<a href="#" onclick="var as=document.getElementsByTagName('input'); for (var i=0;i&lt;as.length;i++) { if (as[i].name.substr(0,10)=='uninstall_') as[i].checked=true; } return false;">{!UNINSTALL}: {!USE_ALL}</a>
			</p>
		</div>
	{+END}

	<form title="{!PRIMARY_PAGE_FORM}" action="{MULTI_ACTION*}" method="post">
		<div class="not_too_tall_addons">
			<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table">
				<thead>
					<tr>
						<th>
							{!NAME}
						</th>
						<th>
							{!AUTHOR}
						</th>
						<th>
							{!VERSION}
						</th>
						<th>
							{!STATUS}
						</th>
						<th>
							{!ACTIONS}
						</th>
					</tr>
				</thead>

				<tbody>
					{ADDONS}
				</tbody>
			</table></div>
		</div>

		<p class="proceed_button">
			<input onclick="disable_button_just_clicked(this);" class="buttons__proceed button_screen" type="submit" value="{!INSTALL_AND_UNINSTALL}" />
		</p>
	</form>
{+END}
{+START,IF_EMPTY,{ADDONS}}
	<p class="nothing_here">
		{!NO_ADDONS_AVAILABLE}
	</p>
{+END}

<h2>{!ACTIONS}</h2>

<ul role="navigation" class="actions_list spaced_list">
	{+START,IF_NON_EMPTY,{UPDATED_ADDONS}}
		<li>
			<a href="{$PAGE_LINK*,_SELF:_SELF:addon_import:to_import={UPDATED_ADDONS}}">{!IMPORT_UPDATED_ADDONS}</a>
		</li>
	{+END}
	<li>
		<a href="{$PAGE_LINK*,_SELF:_SELF:addon_import}">{!IMPORT_ADDON}</a> ({!IMPORT_ADDON_2})
	</li>
	<li>
		<a href="{$PAGE_LINK*,_SELF:_SELF:addon_export}">{!EXPORT_ADDON_TITLE}</a>
	</li>
	<li>
		{!ADVANCED}: <a href="{$PAGE_LINK*,_SELF:_SELF:modules}">{!MODULE_MANAGEMENT}</a>
	</li>
</ul>

