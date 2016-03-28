{+START,IF,{$NOT,{$WIDE_HIGH}}}
	{+START,IF,{$JS_ON}}
		{+START,IF_NON_EMPTY,{$MESSAGES_TOP}}
			<div class="global_messages">
				{$MESSAGES_TOP}
			</div>
		{+END}
	{+END}
{+END}

{$REQUIRE_JAVASCRIPT,checking}

<form class="form_table" title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" enctype="multipart/form-data" id="main_form">
	{$INSERT_SPAMMER_BLACKHOLE}

	{HIDDEN}

	{+START,IF,{$GT,{TABS},1}}
		<div class="{$?,{$MOBILE},modern_tabs,modern_subtabs}">
			<div class="{$?,{$MOBILE},modern_tab_headers,modern_subtab_headers}">
				{+START,LOOP,TABS}
					<div id="t_edit__{$LCASE,{TAB_TITLE|*}}"{+START,IF,{TAB_FIRST}} class="tab_active tab_first{+END}{+START,IF,{TAB_LAST}} tab_last{+END}">
						<a aria-controls="g_edit__{$LCASE,{TAB_TITLE|*}}" role="tab" href="#" onclick="select_tab('g','edit__{$LCASE,{TAB_TITLE|*}}'); return false;">{+START,IF_NON_EMPTY,{TAB_ICON}}<img alt="" src="{$IMG*,icons/24x24/{TAB_ICON}}" srcset="{$IMG*,icons/48x48/{TAB_ICON}} 2x" /> {+END}<span>{TAB_TITLE*}</span></a>
					</div>
				{+END}
			</div>
			<div class="{$?,{$MOBILE},modern_tab_bodies,modern_subtab_bodies}">
	{+END}
				{+START,LOOP,TABS}
					{+START,IF,{$GT,{TABS},1}}
					<div aria-labeledby="t_edit__{$LCASE,{TAB_TITLE|*}}" role="tabpanel" id="g_edit__{$LCASE,{TAB_TITLE|*}}" style="display: {$?,{$OR,{TAB_FIRST},{$NOT,{$JS_ON}}},block,none}">
						<a id="tab__edit__{$LCASE,{TAB_TITLE|*}}"></a>
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
							<div class="wide_table_wrap"><table class="map_table form_table wide_table">
								{+START,IF,{$NOT,{$MOBILE}}}
									<colgroup>
										<col class="field_name_column_shorter" />
										<col class="field_input_column" />
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
		{+END}
	{+END}
</form>
