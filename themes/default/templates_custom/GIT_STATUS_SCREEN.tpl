{TITLE}

<div class="meta_details" role="note">
	<ul class="meta_details_list">
		<li><strong>Branch</strong>: <kbd>{BRANCH*}</kbd></li>
		<li><strong>Unsynched local commits</strong>: {NUM_UNSYNCHED_LOCAL_COMMITS*}</li>
		<li><strong>Unsynched remote commits</strong>: {NUM_UNSYNCHED_REMOTE_COMMITS*}</li>
	</ul>
</div>

<form id="git_status_form" action="{$SELF_URL*,0,0,0,type=action,include_ignored={INCLUDE_IGNORED}}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<input type="hidden" name="action" value="" />

	<h2>Local files</h2>

	<div class="wide_table_wrap"><table class="columned_table wide_table results_table">
		<colgroup>
			<col style="width: 60%" />
			<col style="width: 40%" />
			<col style="width: 75px" />
			<col style="width: 200px" />
			<col style="width: 100px" />
			<col style="width: 35px" />
		</colgroup>

		<thead>
			<th>File path</th>
			<th>File name</th>
			<th>File size</th>
			<th>Last modified</th>
			<th>Status</th>
			<th></th>
		</head>

		<tbody>
			{+START,IF,{$NOT,{HAS_LOCAL_FILES}}}
				<tr>
					<td colspan="6"><p class="nothing_here">{!NO_ENTRIES}</p></td>
				</tr>
			{+END}
			{+START,IF,{HAS_LOCAL_FILES}}
				{+START,LOOP,LOCAL_FILES}
					<tr>
						<td>
							{DIRECTORY*}{+START,IF_NON_EMPTY,{DIRECTORY}}/{+END}
						</td>
						<td>
							{+START,IF,{$EQ,{_GIT_STATUS},{$GIT_STATUS__MODIFIED}}}
								<a href="{$PAGE_LINK*,_SELF:_SELF:local_diff:{PATH&}}" target="_blank" title="View diff for {PATH*} {!LINK_NEW_WINDOW}" onclick="return open_link_as_overlay(this);">{$TRUNCATE_LEFT,{FILENAME},50}</a>
							{+END}
							{+START,IF,{$NEQ,{_GIT_STATUS},{$GIT_STATUS__MODIFIED}}}
								{$TRUNCATE_LEFT,{FILENAME},50}
							{+END}
						</td>

						<td>
							{+START,IF_PASSED,FILE_SIZE}
								{FILE_SIZE*}
							{+END}
							{+START,IF_NON_PASSED,FILE_SIZE}
								<em>Unknown</em>
							{+END}
						</td>
						<td>
							{+START,IF_PASSED,MTIME}
								{MTIME*}
							{+END}
							{+START,IF_NON_PASSED,MTIME}
								<em>Unknown</em>
							{+END}
						</td>

						<td>{GIT_STATUS*}</td>

						<td>
							<label for="local_select_{PATH_HASH*}" class="accessibility_hidden">Select {PATH*}</label>
							<input type="checkbox" name="local_select_{PATH_HASH*}" id="local_select_{PATH_HASH*}" value="{PATH*}" onclick="refresh_file_selection();" />
						</td>
					</tr>
				{+END}
			{+END}

			<tr>
				<td colspan="6">
					{+START,IF,{$NOT,{INCLUDE_IGNORED}}}
						<input type="submit" class="button_screen_item buttons__all" value="Refresh with ignored files" onclick="this.form.elements['action'].value='include';" />
					{+END}
					{+START,IF,{INCLUDE_IGNORED}}
						<input type="submit" class="button_screen_item buttons__all2" value="Refresh without ignored files" onclick="this.form.elements['action'].value='exclude';" />
					{+END}

					<input type="button" class="button_screen_item buttons__calculate" value="Shell paths" onclick="show_shell_paths('local_select_');" id="button_local_shell_paths" disabled="disabled" />

					<input type="submit" class="button_screen_item buttons__copy" value="Download TAR" onclick="this.form.elements['action'].value='local_tar';" id="button_local_tar" disabled="disabled" />

					<input type="button" class="button_screen_item menu___generic_admin__delete" value="Delete/revert files" onclick="var _form=this.form; fauxmodal_confirm('Are you sure you want to delete the local changes?',function(result) { if (result) { _form.elements['action'].value='revert'; _form.submit(); } });" id="button_revert" disabled="disabled" />

					<input style="float: right" type="button" class="button_micro buttons__choose" value="Select all" onclick="select_all_git_files('local_select_',true);" />
					<input style="float: right" type="button" class="button_micro buttons__choose" value="Select none" onclick="select_all_git_files('local_select_',false);" />
				</td>
			</tr>
		</tbody>
	</table></div>

	<h2>Remote files</h2>

	<div class="wide_table_wrap"><table class="columned_table wide_table results_table">
		<colgroup>
			<col style="width: 60%" />
			<col style="width: 40%" />
			<col style="width: 75px" />
			<col style="width: 200px" />
			<col style="width: 100px" />
			<col style="width: 35px" />
		</colgroup>

		<thead>
			<th>File path</th>
			<th>File name</th>
			<th>File size</th>
			<th>Last modified</th>
			<th>Status</th>
			<th></th>
		</head>

		<tbody>
			{+START,IF,{$NOT,{HAS_REMOTE_FILES}}}
				<tr>
					<td colspan="6"><p class="nothing_here">{!NO_ENTRIES}</p></td>
				</tr>
			{+END}
			{+START,IF,{HAS_REMOTE_FILES}}
				{+START,LOOP,REMOTE_FILES}
					<tr>
						<td>
							{DIRECTORY*}{+START,IF_NON_EMPTY,{DIRECTORY}}/{+END}
						</td>
						<td>
							{+START,IF,{$EQ,{_GIT_STATUS},{$GIT_STATUS__MODIFIED}}}
								<a href="{$PAGE_LINK*,_SELF:_SELF:remote_diff:{PATH&}}" target="_blank" title="View diff for {PATH*} {!LINK_NEW_WINDOW}" onclick="return open_link_as_overlay(this);">{$TRUNCATE_LEFT,{FILENAME},50}</a>
							{+END}
							{+START,IF,{$NEQ,{_GIT_STATUS},{$GIT_STATUS__MODIFIED}}}
								{$TRUNCATE_LEFT,{FILENAME},50}
							{+END}
						</td>

						<td>
							{+START,IF_PASSED,FILE_SIZE}
								{FILE_SIZE*}
							{+END}
							{+START,IF_NON_PASSED,FILE_SIZE}
								<em>Unknown</em>
							{+END}
						</td>
						<td>
							{+START,IF_PASSED,MTIME}
								{MTIME*}
							{+END}
							{+START,IF_NON_PASSED,MTIME}
								<em>Unknown</em>
							{+END}
						</td>

						<td>
							{GIT_STATUS*}
						</td>

						<td>
							<label for="remote_select_{PATH_HASH*}" class="accessibility_hidden">Select {PATH*}</label>
							<input type="checkbox" name="remote_select_{PATH_HASH*}" id="remote_select_{PATH_HASH*}" value="{PATH*}" onclick="refresh_file_selection();"{+START,IF,{$NOT,{EXISTS_LOCALLY}}} disabled="disabled"{+END} />
						</td>
					</tr>
				{+END}

				{+START,IF,{HAS_MAX_REMOTE_FILES}}
					<tr>
						<td colspan="6">
							<p class="nothing_here">Too many files to show</p>
						</td>
					</tr>
				{+END}
			{+END}

			<tr>
				<td colspan="6">
					<input type="button" class="button_screen_item buttons__calculate" value="Shell paths" onclick="show_shell_paths('remote_select_');" id="button_remote_shell_paths" disabled="disabled" />

					<input type="submit" class="button_screen_item buttons__save" value="Download TAR (to backup what would be overwritten)" onclick="this.form.elements['action'].value='remote_tar';" id="button_remote_tar" disabled="disabled" />

					<input style="float: right" type="button" class="button_micro buttons__choose" value="Select all" onclick="select_all_git_files('remote_select_',true);" />
					<input style="float: right" type="button" class="button_micro buttons__choose" value="Select none" onclick="select_all_git_files('remote_select_',false);" />
				</td>
			</tr>
		</tbody>
	</table></div>
</form>

<form id="git_status_form" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,0,0,type=browse,sort=<null>,include_ignored={INCLUDE_IGNORED}}}" method="get">
	{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,0,0,sort=<null>,include_ignored=<null>}}

	<p>
		<label for="sort">Sort by</label>:
		<select name="sort" id="sort">
			<option{+START,IF,{$EQ,{SORT},path ASC}} selected="selected"{+END} value="path ASC">Path (A-Z)</option>
			<option{+START,IF,{$EQ,{SORT},path DESC}} selected="selected"{+END} value="path DESC">Path (Z-A)</option>
			<option{+START,IF,{$EQ,{SORT},file_size ASC}} selected="selected"{+END} value="file_size ASC">File size (small to big)</option>
			<option{+START,IF,{$EQ,{SORT},file_size DESC}} selected="selected"{+END} value="file_size DESC">File size (big to small)</option>
			<option{+START,IF,{$EQ,{SORT},mtime ASC}} selected="selected"{+END} value="mtime ASC">Last modified (oldest first)</option>
			<option{+START,IF,{$EQ,{SORT},mtime DESC}} selected="selected"{+END} value="mtime DESC">Last modified (newest first)</option>
			<option{+START,IF,{$EQ,{SORT},git_status ASC}} selected="selected"{+END} value="git_status ASC">Git status</option>
		</select>
		<input type="submit" class="button_micro buttons__sort" value="Sort" />
	</p>
</form>

<script>// <![CDATA[
	function select_all_git_files(stub,select)
	{
		var form=document.getElementById('git_status_form');

		for (var i=0;i<form.elements.length;i++) {
			if ((form.elements[i].nodeName.toLowerCase()=='input') && (form.elements[i].name.substring(0,stub.length)==stub) && (!form.elements[i].disabled)) {
				form.elements[i].checked=select;
			}
		}

		refresh_file_selection();
	}

	function refresh_file_selection()
	{
		var has_selection;

		has_selection=_refresh_file_selection('local_select_');
		document.getElementById('button_local_tar').disabled=!has_selection;
		document.getElementById('button_local_shell_paths').disabled=!has_selection;
		document.getElementById('button_revert').disabled=!has_selection;

		has_selection=_refresh_file_selection('remote_select_');
		document.getElementById('button_remote_tar').disabled=!has_selection;
		document.getElementById('button_remote_shell_paths').disabled=!has_selection;
	}

	function _refresh_file_selection(stub)
	{
		var form=document.getElementById('git_status_form');

		for (var i=0;i<form.elements.length;i++) {
			if ((form.elements[i].nodeName.toLowerCase()=='input') && (form.elements[i].name.substring(0,stub.length)==stub) && (form.elements[i].checked) && (!form.elements[i].disabled)) {
				return true;
			}
		}

		return false;
	}

	function show_shell_paths(stub,paths)
	{
		var notice='';

		var form=document.getElementById('git_status_form');

		for (var i=0;i<form.elements.length;i++) {
			if ((form.elements[i].nodeName.toLowerCase()=='input') && (form.elements[i].name.substring(0,stub.length)==stub) && (form.elements[i].checked) && (!form.elements[i].disabled)) {
				if (notice!='') {
					notice+=' \\\n';
				}
				notice+=form.elements[i].value;
			}
		}

		fauxmodal_alert(notice,null,'Paths');
	}
//]]></script>
