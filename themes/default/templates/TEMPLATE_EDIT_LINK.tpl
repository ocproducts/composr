{$REQUIRE_JAVASCRIPT,core_themeing}
{$,Will produce invalid XHTML, but we try and make it look nice}

{+START,IF_NON_EMPTY,{$TRIM,{CONTENTS}}}
	{+START,SET,tpl_marker_open}
		<span class="template-edit-link-wrap" style="border-color: {$CYCLE*,tpl_cycle,aqua,blue,fuchsia,gray,green,lime,maroon,navy,olive,purple,red,silver,teal};">
	{+END}

	{+START,SET,tpl_marker_link}
		{$,NB: We do not use an anchor tag because nested anchors make a mess}
		<span data-tpl="templateEditLink" data-tpl-params="{+START,PARAMS_JSON,EDIT_URL}{_*}{+END}" data-cms-tooltip="{ contents: '&lt;p&gt;{!TEMPLATES_WITH_EDIT_LINKS_PARAMETERS;^=}&lt;/p&gt;{PARAM_INFO;^*}', width: '800px', delay: 0 }" class="template-edit-link associated-link">
			<span class="js-click-open-edit-url js-keypress-open-edit-url"><kbd>{CODENAME*}.tpl</kbd></span>
		</span>
	{+END}

	{+START,SET,tpl_marker_close}
		</span>
	{+END}

	{$,Decide whether we can show it now (otherwise it will defer) }
	{$SET,tpl_go_ahead,{$AND,{$NOT,{$PREG_MATCH,^\s*<(td|tr|th),{CONTENTS}}},{$IN_STR,{CONTENTS},<}}}

	{+START,IF,{$GET,tpl_go_ahead}}
		{$GET,tpl_marker_open}
		{CONTENTS`}
		{$GET,tpl_marker_link}
		{$GET,tpl_marker_close}

		{$SET,tpl_marker_open,}
		{$SET,tpl_marker_link,}
		{$SET,tpl_marker_close,}
	{+END}

	{+START,IF,{$NOT,{$GET,tpl_go_ahead}}}
		<!-- {CODENAME/}.tpl -->
		{CONTENTS`}
	{+END}
{+END}
