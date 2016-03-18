{TITLE}

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<div class="box box___catalogue_default_category_screen__description"><div class="box_inner">
		<div itemprop="description">
			{DESCRIPTION}
		</div>
	</div></div>
{+END}

{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,catalogue_category,{ID}}}
{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}
	{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}

	<hr class="spaced_rule" />
{+END}

{+START,IF_NON_EMPTY,{SUBCATEGORIES}}
	<div class="box box___catalogue_category_screen"><div class="box_inner compacted_subbox_stream">
		<h2>{!SUBCATEGORIES_HERE}</h2>

		<div>
			{SUBCATEGORIES}
		</div>
	</div></div>
{+END}

{ENTRIES}

{$REVIEW_STATUS,catalogue_category,{ID}}

{+START,IF,{$CONFIG_OPTION,show_content_tagging}}{TAGS}{+END}

{+START,INCLUDE,NOTIFICATION_BUTTONS}
	NOTIFICATIONS_TYPE=catalogue_entry__{CATALOGUE}
	NOTIFICATIONS_ID={ID}
	BREAK=1
	RIGHT=1
{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={ADD_ENTRY_URL*}
	1_TITLE={!CATALOGUE_GENERIC_ADD,{_TITLE*}}
	1_REL=add
	1_ICON=menu/_generic_admin/add_one
	2_URL={ADD_CAT_URL*}
	2_TITLE={!CATALOGUE_GENERIC_ADD_CATEGORY,{_TITLE*}}
	2_REL=add
	2_ICON=menu/_generic_admin/add_one_category
	3_ACCESSKEY=q
	3_URL={EDIT_CAT_URL*}
	3_TITLE={!CATALOGUE_GENERIC_EDIT_CATEGORY,{_TITLE*}}
	3_REL=edit
	3_ICON=menu/_generic_admin/edit_this_category
	4_URL={EDIT_CATALOGUE_URL*}
	4_TITLE={!EDIT_CATALOGUE}
	4_ICON=menu/cms/catalogues/edit_this_catalogue
{+END}

{+START,IF,{$CONFIG_OPTION,show_screen_actions}}{$BLOCK,failsafe=1,block=main_screen_actions,title={$METADATA,title}}{+END}

{$,Display top/recent entries. By default it is only shown on the A-Z screen, which has a blank ID}
{+START,IF_NON_EMPTY,{SUBCATEGORIES}}{+START,IF,{$EQ,{ID},}}
	<hr class="spaced_rule" />

	<div class="boxless_space">
		{+START,BOX}{$BLOCK,block=main_multi_content,param=catalogue_entry,filter={$?,{$IS_NON_EMPTY,{ID}},{ID}*},no_links=1,efficient=0,give_context=0,include_breadcrumbs=1,render_if_empty=1,max=10,mode=recent,title={!RECENT,10,{!ENTRIES}}}{+END}

		{+START,IF,{$CONFIG_OPTION,is_on_rating}}
			{+START,BOX}{$BLOCK,block=main_multi_content,param=catalogue_entry,filter={$?,{$IS_NON_EMPTY,{ID}},{ID}*},no_links=1,efficient=0,give_context=0,include_breadcrumbs=1,render_if_empty=1,max=10,mode=top,title={!TOP,10,{!ENTRIES}}}{+END}
		{+END}
	</div>
{+END}{+END}
