<div class="flow_mode_thumb">
	{+START,IF,{$HAS_DELETE_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries}}
		{+START,INCLUDE,MASS_SELECT_MARKER}
			TYPE={TYPE}
			ID={ID}
		{+END}
	{+END}

	<a href="{VIEW_URL*}">{$TRIM,{THUMB}}</a>

	{+START,IF,{$SUPPORTS_FRACTIONAL_EDITABLE,_SEARCH:cms_galleries:{$?,{$EQ,{TYPE},video},__edit_other,__edit}:{ID},{$HAS_EDIT_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries,galleries,{CAT}}}}
		<p>
			{+START,FRACTIONAL_EDITABLE,{_TITLE},title,_SEARCH:cms_galleries:{$?,{$EQ,{TYPE},video},__edit_other,__edit}:{ID},1,1,{$HAS_EDIT_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries,galleries,{CAT}}}{_TITLE*}{+END}
		</p>
	{+END}
</div>
