<span class="vertical-alignment">
	<img data-cms-tooltip="{$CNS_MEMBER_HTML*,{ID}}" width="18" height="18" src="{$THUMBNAIL*,{$?,{$IS_EMPTY,{$AVATAR,{ID}}},{$IMG,cns_default_avatars/default},{$AVATAR,{ID}}},18x18,,,{$IMG,cns_default_avatars/default}}" alt="" />

	<a href="{URL*}">{$DISPLAYED_USERNAME*,{NAME}}</a>
</span>
