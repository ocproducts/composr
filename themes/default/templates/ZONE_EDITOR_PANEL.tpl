{$REQUIRE_JAVASCRIPT,plupload}
{$SET,IDH,{$REPLACE*,_,-,{ID}}}
<div data-view="ZoneEditorPanel" data-view-params="{+START,PARAMS_JSON,COMCODE,CLASS,ID,CURRENT_ZONE}{_*}{+END}">
	<div class="block-mobile">
		 <h2>{ID*}</h2>
	</div>

	{$,Tab buttons}
	<div class="float-surrounder">
		<div class="ze-tabs tabs" role="tablist">
			{+START,IF_PASSED,PREVIEW}
				<a aria-controls="view-{$GET,IDH}" role="tab" title="{!PREVIEW}: {ID*}" href="#!" id="view_tab_{ID*}" class="tab tab-first tab_selected js-click-select-tab" data-js-tab="view"><img alt="" src="{$IMG*,icons/24x24/tabs/preview}" srcset="{$IMG*,icons/48x48/tabs/preview} 2x" /> <span>{!PREVIEW}</span></a>
			{+END}
			{+START,IF_PASSED,COMCODE}
				<a aria-controls="edit-{$GET,IDH}" role="tab" title="{!EDIT}: {ID*}" href="#!" id="edit_tab_{ID*}" class="tab{+START,IF_NON_PASSED,PREVIEW} tab-first{+END} js-click-select-tab" data-js-tab="edit"><img alt="" src="{$IMG*,icons/24x24/tabs/edit}" srcset="{$IMG*,icons/48x48/tabs/edit} 2x" /> <span>{!EDIT}</span></a>
			{+END}
			<a aria-controls="info-{$GET,IDH}" role="tab" title="{!DETAILS}: {ID*}" href="#!" id="info_tab_{ID*}" class="tab{+START,IF_NON_PASSED,SETTINGS} tab-last{+END}{+START,IF_NON_PASSED,PREVIEW}{+START,IF_NON_PASSED,COMCODE} tab-first{+END}{+END} js-click-select-tab" data-js-tab="info"><img alt="" src="{$IMG*,icons/24x24/menu/_generic_spare/page}" srcset="{$IMG*,icons/48x48/menu/_generic_spare/page} 2x" /> <span>{!DETAILS}</span></a>
			{+START,IF_PASSED,SETTINGS}
				<a aria-controls="settings-{$GET,IDH}" role="tab" title="{!SETTINGS}: {ID*}" href="#!" id="settings_tab_{ID*}" class="tab tab-last js-click-select-tab" data-js-tab="settings"><img alt="" src="{$IMG*,icons/24x24/tabs/settings}" srcset="{$IMG*,icons/48x48/tabs/settings} 2x" /> <span>{!SETTINGS}</span></a>
			{+END}
		</div>
	</div>

	{$,Actual tab' contents follows}

	{+START,IF_PASSED,PREVIEW}
		<div id="view-{$GET,IDH}" style="display: block" aria-labeledby="view_tab_{ID*}" role="tabpanel">
			{+START,IF_EMPTY,{PREVIEW}}
				<p class="nothing-here">{!NONE}</p>
			{+END}
			{+START,IF_NON_EMPTY,{PREVIEW}}
				{$PARAGRAPH,{PREVIEW}}
			{+END}
		</div>
	{+END}

	{+START,IF_PASSED,COMCODE}
		<div id="edit-{$GET,IDH}" style="{+START,IF_NON_PASSED,PREVIEW}display: block{+END}{+START,IF_PASSED,PREVIEW}display: none{+END}" aria-labeledby="edit_tab_{ID*}" role="tabpanel">
			<form title="{ID*}: {!COMCODE}" action="index.php" method="post" autocomplete="off" class="js-form-zone-editor-comcode">
				{$INSERT_SPAMMER_BLACKHOLE}

				<p>
					<label for="edit_{ID*}_textarea">{!COMCODE}:</label> <a data-open-as-overlay="{}" class="link-exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SEARCH:userguide_comcode}"><img alt="{!COMCODE_MESSAGE,Comcode}" src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" class="vertical-alignment" /></a>
					{+START,IF,{$IN_STR,{CLASS},wysiwyg}}
						<span class="horiz-field-sep associated-link"><a id="toggle_wysiwyg_edit_{ID*}_textarea" href="#!" class="js-a-toggle-wysiwyg"><abbr title="{!TOGGLE_WYSIWYG_2}"><img src="{$IMG*,icons/16x16/editor/wysiwyg_on}" srcset="{$IMG*,icons/32x32/editor/wysiwyg_on} 2x" alt="{!comcode:ENABLE_WYSIWYG}" title="{!comcode:ENABLE_WYSIWYG}" class="vertical-alignment" /></abbr></a></span>
					{+END}
				</p>
				{+START,IF_NON_EMPTY,{COMCODE_EDITOR}}
					<div>
						<div class="post-special-options">
							<div class="float-surrounder" role="toolbar">
								{COMCODE_EDITOR}
							</div>
						</div>
		</div>
				{+END}
				<div>
					<textarea rows="50" cols="20" class="{$?,{IS_PANEL},ze-textarea,ze-textarea-middle} {CLASS*} js-ta-ze-comcode textarea-scroll" id="edit_{ID*}_textarea" name="{ID*}">{COMCODE*}</textarea>

					{+START,IF_PASSED,DEFAULT_PARSED}
						<textarea cols="1" rows="1" style="display: none" readonly="readonly" disabled="disabled" name="edit_{ID*}_textarea_parsed">{DEFAULT_PARSED*}</textarea>
					{+END}
				</div>
			</form>
		</div>
	{+END}

	<div id="info-{$GET,IDH}" style="{+START,IF_NON_PASSED,PREVIEW}display: block{+END}{+START,IF_PASSED,PREVIEW}display: none{+END}" aria-labeledby="info_tab_{ID*}" role="tabpanel">
		<p class="lonely-label">
			<span class="field-name">{!PAGE_TYPE}:</span>
		</p>
		<p>{TYPE*}</p>

		<p class="lonely-label">
			<span class="field-name">{!NAME}:</span>
		</p>
		<p><kbd>{ID*}</kbd></p>

		{+START,IF_NON_EMPTY,{EDIT_URL}}
			<p class="lonely-label">
				<span class="field-name">{!ACTIONS}:</span>
			</p>
			<ul class="actions-list">
				<li><a title="{!EDIT_IN_FULL_PAGE_EDITOR}: {ID*} {!LINK_NEW_WINDOW}" target="_blank" href="{EDIT_URL*}">{!EDIT_IN_FULL_PAGE_EDITOR}</a></li>
			</ul>
		{+END}

		{$,Choosing where to redirect to, same page name but in a different zone}
		{+START,IF_PASSED,ZONES}
			{+START,IF,{$ADDON_INSTALLED,redirects_editor}}
				<form title="{ID*}: {!DRAWS_FROM}" action="index.php" method="post" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<p class="lonely-label">
						<label for="redirect_{ID*}" class="field-name">{!DRAWS_FROM}:</label>
					</p>
					{+START,IF_NON_EMPTY,{ZONES}}
						<select class="js-sel-zones-draw" id="redirect_{ID*}" name="redirect_{ID*}">
							<option value="{ZONE*}">{!NA}</option>
							{ZONES}
						</select>
					{+END}
					{+START,IF_EMPTY,{ZONES}}
						<input maxlength="80" class="js-inp-zones-draw" size="20" id="redirect_{ID*}" name="redirect_{ID*}" value="{CURRENT_ZONE*}" type="text" />
					{+END}
				</form>
			{+END}
		{+END}
	</div>

	{+START,IF_PASSED,SETTINGS}
		<div id="settings-{$GET,IDH}" style="display: none" aria-labeledby="settings_tab_{ID*}" role="tabpanel">
			<form title="{ID*}: {!SETTINGS}" id="middle_fields" action="index.php" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="wide-table-wrap"><table class="map-table form-table wide-table">
					{+START,IF,{$DESKTOP}}
						<colgroup>
							<col class="field-name-column" />
							<col class="field-input-column" />
						</colgroup>
					{+END}

					<tbody>
						{SETTINGS}
					</tbody>
				</table></div>
			</form>
		</div>
	{+END}
</div>
