{+START,IF,{$NOR,{IS_PANEL},{BEING_INCLUDED}}}
	{+START,IF_EMPTY,{$TRIM,{CONTENT}}}
		<p class="nothing_here">{!NO_PAGE_OUTPUT}</p>
	{+END}
{+END}

{+START,IF,{$OR,{$NOT,{IS_PANEL}},{$IS_NON_EMPTY,{$TRIM,{CONTENT}}}}}
	<div class="comcode_page">
		{WARNING_DETAILS}

		{$TRIM,{CONTENT}}

		{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,comcode_page,{NATIVE_ZONE}:{NAME}}}
		{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

		{+START,IF,{SHOW_AS_EDIT}}{+START,IF_NON_EMPTY,{EDIT_DATE_RAW}}
			<div class="edited" role="note">
				<img alt="" src="{$IMG*,1x/edited}" srcset="{$IMG*,2x/edited} 2x" />
				{!EDITED}
				<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{EDIT_DATE_RAW}}" itemprop="datePublished">{$DATE*,,,,{EDIT_DATE_RAW}}</time>
			</div>
		{+END}{+END}

		{+START,IF,{$NOR,{IS_PANEL},{$EQ,{NAME},rules,start},{$WIDE_HIGH},{IS_PANEL},{BEING_INCLUDED},{$GET,already_loaded_screen_actions}}}
			{+START,IF,{$CONFIG_OPTION,show_screen_actions}}
				{$REQUIRE_CSS,{$?,{$CONFIG_OPTION,show_screen_actions},screen_actions}}
				{$BLOCK-,failsafe=1,block=main_screen_actions}
			{+END}

			{$REVIEW_STATUS,comcode_page,{NATIVE_ZONE}:{NAME}}

			{+START,IF,{$CONFIG_OPTION,show_content_tagging}}{TAGS}{+END}
		{+END}

		{+START,IF_NON_EMPTY,{EDIT_URL}}
			{+START,IF,{IS_PANEL}}
				{+START,IF,{$EQ,{NAME},panel_left,panel_right}}
					<p class="quick_self_edit_link associated_link">
						<a onclick="return open_link_as_overlay(this);" class="link_exempt" title="{!COMCODE_MESSAGE,Comcode} {!LINK_NEW_WINDOW}" target="_blank" href="{$PAGE_LINK*,_SEARCH:userguide_comcode}"><img alt="" width="16" height="16" src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" /></a>
						<a href="{EDIT_URL*}" title="{$?,{$HAS_ZONE_ACCESS,adminzone},{!EDIT_ZONE_EDITOR},{!EDIT_PAGE}}: {NAME*} ({!IN,&quot;{$?,{$IS_EMPTY,{$ZONE}},{!_WELCOME},{$ZONE*}}&quot;})"><span>{$?,{$HAS_ZONE_ACCESS,adminzone},{!EDIT_ZONE_EDITOR},{!EDIT_PAGE}}</span></a>
					</p>
				{+END}

				{+START,IF,{$EQ,{NAME},panel_top,panel_bottom}}
					<div>
						<a class="edit_page_link_inline" href="{EDIT_URL*}"><img width="17" height="17" title="{!EDIT_PAGE}: {NAME*}" alt="{!EDIT_PAGE}: {NAME*}" src="{$IMG*,icons/16x16/editor/comcode}" srcset="{$IMG*,icons/32x32/editor/comcode} 2x" /></a>
					</div>
				{+END}
			{+END}

			{+START,IF,{$NOR,{IS_PANEL},{$GET,no_comcode_page_edit_links}}}
				{+START,INCLUDE,STAFF_ACTIONS}
					1_URL={EDIT_URL*}
					1_TITLE={$?,{BEING_INCLUDED},&uarr; {!EDIT},{!EDIT_PAGE}}
					1_NOREDIRECT=1
					1_ACCESSKEY=q
					1_REL=edit
					1_ICON=menu/_generic_admin/edit_this
					2_URL={$?,{$GET,has_comcode_page_children_block},{ADD_CHILD_URL*}}
					2_TITLE={!ADD_CHILD_PAGE}
					2_REL=add
					2_ICON=menu/_generic_admin/add_one
				{+END}
			{+END}
		{+END}
	</div>
{+END}
