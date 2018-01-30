{+START,IF,{$NOT,{$WIDE_HIGH}}}
	{+START,IF_NON_EMPTY,{$MESSAGES_TOP}}
		<div class="global-messages">
			{$MESSAGES_TOP}
		</div>
	{+END}
{+END}

{$REQUIRE_JAVASCRIPT,core_cns}
{$REQUIRE_JAVASCRIPT,checking}

<form data-tpl="cnsMemberProfileEdit" data-tpl-params="{+START,PARAMS_JSON,TABS}{_*}{+END}" class="form-table" title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" enctype="multipart/form-data" id="main_form" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{HIDDEN}

	{+START,IF,{$GT,{TABS},1}}
		<div class="{$?,{$MOBILE},modern-tabs,modern-subtabs}">
			<div class="{$?,{$MOBILE},modern-tab-headers,modern-subtab-headers}">
				{+START,LOOP,TABS}
					<div id="t_edit__{$LCASE,{TAB_CODE|*}}"{+START,IF,{TAB_FIRST}} class="tab-active tab-first{+END}{+START,IF,{TAB_LAST}} tab-last{+END}">
						<a class="js-click-select-edit-tab" data-tp-tab-code="{TAB_CODE*}" aria-controls="g_edit__{$LCASE,{TAB_CODE|*}}" role="tab" href="#!">{+START,IF_NON_EMPTY,{TAB_ICON}}<img alt="" width="24" height="24" src="{$IMG*,icons/48x48/{TAB_ICON}}" /> {+END}<span>{TAB_TITLE*}</span></a>
					</div>
				{+END}
			</div>
			<div class="{$?,{$MOBILE},modern-tab-bodies,modern-subtab-bodies}">
	{+END}
				{+START,LOOP,TABS}
					{+START,IF,{$GT,{TABS},1}}
					<div aria-labeledby="t_edit__{$LCASE,{TAB_CODE|*}}" role="tabpanel" id="g_edit__{$LCASE*,{TAB_CODE|}}" style="display: {$?,{TAB_FIRST},block,none}">
						<a id="tab__edit__{$LCASE,{TAB_CODE|*}}"></a>
					{+END}

						{+START,IF_NON_EMPTY,{TAB_TEXT}}
							{$PARAGRAPH,{TAB_TEXT}}
						{+END}

						{+START,IF_NON_PASSED_OR_FALSE,SKIP_REQUIRED}
							{+START,IF,{$IN_STR,{TAB_FIELDS},_required}}
								{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
							{+END}
						{+END}

						{+START,IF,{TAB_SINGLE_FIELD}}
							{TAB_FIELDS}
						{+END}

						{+START,IF,{$NOT,{TAB_SINGLE_FIELD}}}
							<div class="wide-table-wrap"><table class="map-table form-table wide-table">
								{+START,IF,{$DESKTOP}}
									<colgroup>
										<col class="field-name-column-shorter" />
										<col class="field-input-column" />
									</colgroup>
								{+END}

								<tbody>
									{TAB_FIELDS}
								</tbody>
							</table></div>
						{+END}

					{+START,IF,{$GT,{TABS},1}}
					</div>
					{+END}
				{+END}
	{+START,IF,{$GT,{TABS},1}}
			</div>
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{SUBMIT_NAME}}
		{+START,INCLUDE,FORM_STANDARD_END}
			FORM_NAME=main_form
			SUPPORT_AUTOSAVE=1
			SECONDARY_FORM=1
		{+END}
	{+END}
</form>
