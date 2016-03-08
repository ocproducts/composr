{+START,IF,{ALLOW_REMOVE}}
	<form id="feed_remove_{LIID*}" class="activities_remove" action="{$PAGE_LINK*,:start}" method="post" onsubmit="return s_update_remove(event,{LIID*});">
		{$INSERT_SPAMMER_BLACKHOLE}

		<input class="remove_cross" type="submit" value="{!REMOVE}" />
	</form>
{+END}

<div class="activities_avatar_box">
	{+START,IF_NON_EMPTY,{ADDON_ICON}}
		<img src="{$THUMBNAIL*,{ADDON_ICON},36x36,addon_icon_normalise,,,pad,both,#FFFFFF00}" />
	{+END}
	{+START,IF_EMPTY,{ADDON_ICON}}
		<img src="{$THUMBNAIL*,{$IMG,icons/48x48/menu/_generic_admin/{$?,{IS_PUBLIC},edit_this,edit_one}},36x36,addon_icon_normalise,,,pad,both,#FFFFFF00}" />
	{+END}

	{+START,SET,commented_out}
		{+START,IF_EMPTY,{AVATAR}}{+START,IF_NON_EMPTY,{$IMG,cns_default_avatars/default,0,,1}}
			<img src="{$THUMBNAIL*,{$IMG,cns_default_avatars/default,0,,1},36x36,addon_avatar_normalise,,,pad,both,#FFFFFF00}" />
		{+END}{+END}
		{+START,IF_NON_EMPTY,{AVATAR}}
			<img src="{$THUMBNAIL*,{AVATAR},36x36,addon_avatar_normalise,,,pad,both,#FFFFFF00}" />
		{+END}
	{+END}
</div>

<div class="activities_line">
	<div class="activity_time right">
		{$MAKE_RELATIVE_DATE*,{DATETIME},1} {!AGO}
	</div>

	{+START,SET,commented_out}
		{+START,IF_PASSED,USERNAME}
			<div class="activity_name left">
				<a href="{MEMBER_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>
			</div>
		{+END}
	{+END}

	<div class="activities_content">
		{$,The main message}
		{+START,IF,{$EQ,{LANG_STRING},RAW_DUMP}}
			{+START,IF,{$EQ,{MODE},all}}
				{!ACTIVITY_SAYS,<a href="{MEMBER_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>,{MESSAGE}}
			{+END}
			{+START,IF,{$NEQ,{MODE},all}}
				{MESSAGE}
			{+END}
		{+END}
		{+START,IF,{$NEQ,{LANG_STRING},RAW_DUMP}}
			{$,Because it is being included, the including templates preprocessor will hit the SET but without any data, so we have an IF_PASSED}
			{+START,SET,named}{+START,IF_PASSED,MEMBER_ID}{$OR,{$NEQ,{MEMBER_IDS},{MEMBER_ID}},{$EQ,{MODE},all}}{+END}{+END}

			{+START,IF,{$GET,named}}
				{!ACTIVITY_HAS,<a href="{MEMBER_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>,{$LCASE,{$SUBSTR,{MESSAGE},0,1}}{$SUBSTR,{MESSAGE},1}}
			{+END}
			{+START,IF,{$NOT,{$GET,named}}}
				{MESSAGE}
			{+END}
		{+END}
	</div>
</div>
