{$,Will produce invalid XHTML, but we try and make it look nice}

{+START,IF_NON_EMPTY,{$TRIM,{CONTENTS}}}
	{+START,SET,tpl_marker_open}
		<span class="template_edit_link_wrap" style="border-color: {$CYCLE*,tpl_cycle,aqua,blue,fuchsia,gray,green,lime,maroon,navy,olive,purple,red,silver,teal};">
	{+END}

	{+START,SET,tpl_marker_link}
		{$,NB: We do not use an anchor tag because nested anchors make a mess}
		<span onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'&lt;p&gt;{!TEMPLATES_WITH_EDIT_LINKS_PARAMETERS;^*}&lt;/p&gt;{PARAM_INFO;^*}','800px',null,null,null,true);" class="template_edit_link associated_link"><span onkeypress="return this.onclick.call(this,event);" onclick="window.open('{EDIT_URL;*}'); return cancel_bubbling(event);"><kbd>{CODENAME*}.tpl</kbd></span></span>
	{+END}

	{+START,SET,tpl_marker_close}
		</span>
	{+END}

	{$,Decide whether we can show it now (otherwise it will defer) }
	{$SET,tpl_go_ahead,{$AND,{$NOT,{$IN_STR,{CONTENTS},<td,<tr,<th}},{$IN_STR,{CONTENTS},<}}}

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
		{CONTENTS`}
	{+END}
{+END}
