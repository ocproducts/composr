{TITLE}

{$REQUIRE_CSS,shopping}

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<div class="box box---catalogue-products-category-screen--description"><div class="box-inner">
		<div itemprop="description">
			{$PARAGRAPH,{DESCRIPTION}}
		</div>
	</div></div>
{+END}

{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,catalogue_category,{ID}}}
{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

{+START,IF_NON_EMPTY,{SUBCATEGORIES}}
	<div class="box box---catalogue-category-screen"><div class="box-inner compacted-subbox-stream">
		<h2>{!SUBCATEGORIES_HERE}</h2>

		<div>
			{SUBCATEGORIES}
		</div>
	</div></div>
{+END}

{ENTRIES}

{+START,IF,{$IN_STR,{ENTRIES},<img}}
	<p class="vertical-alignment">
		{+START,INCLUDE,ICON}
			NAME=help
			ICON_SIZE=24
		{+END}
		<span>{!HOVER_FOR_FULL}</span>
	</p>
{+END}

{$REVIEW_STATUS,catalogue_category,{ID}}

{+START,IF,{$THEME_OPTION,show_content_tagging}}{TAGS}{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}

{+START,INCLUDE,STAFF_ACTIONS}
	1_URL={ADD_ENTRY_URL*}
	1_TITLE={!do_next:NEXT_ITEM_add}
	1_REL=add
	1_ICON=admin/add
	2_URL={ADD_CAT_URL*}
	2_TITLE={!do_next:NEXT_ITEM_add_one_category}
	2_REL=add
	2_ICON=admin/add_one_category
	3_ACCESSKEY=q
	3_URL={EDIT_CAT_URL*}
	3_TITLE={!do_next:NEXT_ITEM_edit_this_category}
	3_REL=edit
	3_ICON=admin/edit_this_category
	4_URL={EDIT_CATALOGUE_URL*}
	4_TITLE={!EDIT_THIS_CATALOGUE}
	4_ICON=menu/cms/catalogues/edit_this_catalogue
{+END}

{+START,IF,{$THEME_OPTION,show_screen_actions}}{$BLOCK,failsafe=1,block=main_screen_actions,title={$METADATA,title}}{+END}
