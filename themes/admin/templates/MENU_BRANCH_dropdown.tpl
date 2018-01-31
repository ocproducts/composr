{+START,SET,branch}
	{$,The line below is just a fudge - we need CHILDREN to evaluate first, so it doesn't interfere with our 'RAND' variable}
	{$SET,HAS_CHILDREN,{$IS_NON_EMPTY,{CHILDREN}}}

	{$SET,RAND,{$RAND}}

	{$SET,img,{$?,{$AND,{$IS_EMPTY,{IMG}},{$LT,{THE_LEVEL},3}},{$IMG,icons/content_types/page},{IMG}}}

	{+START,IF,{TOP_LEVEL}}
		<li class="dropdown-menu-item {$?,{CURRENT},current,non-current}{$?,{$GET,HAS_CHILDREN}, has-children}{+START,IF,{$AND,{$NOT,{$GET,HAS_CHILDREN}},{LAST}}} last{+END}{+START,IF,{FIRST}} first{+END} toplevel {+START,IF,{$GET,HAS_CHILDREN}}js-mousemove-timer-pop-up-menu js-mouseout-clear-pop-up-timer{+END}" data-vw-rand="{$GET*,RAND}">
			<a {+START,INCLUDE,MENU_LINK_PROPERTIES}{+END} class="dropdown-menu-item-a {+START,IF_EMPTY,{URL}}non-link {+END}toplevel-link{+START,IF,{LAST}} last{+END}{+START,IF,{FIRST}} first{+END} {$?,{$GET,HAS_CHILDREN},js-focus-pop-up-menu js-click-unset-active-menu js-click-toggle-sub-menu}" {$?,{$GET,HAS_CHILDREN},data-vw-sub-menu-id="{MENU|*}_dexpand_{$GET*,RAND}"}>{+START,IF_NON_EMPTY,{$GET,img}}<img class="dropdown-menu-item-img" alt="" width="32" height="32" src="{$GET,img}" /> {+END}<span class="dropdown-menu-item-caption">{CAPTION}</span></a>
			{+START,IF,{$GET,HAS_CHILDREN}}{+START,IF,{$DESKTOP}}
				<ul aria-haspopup="true" class="dropdown-menu-items nlevel js-mouseover-set-active-menu js-mouseout-unset-active-menu" id="{MENU|*}_dexpand_{$GET*,RAND}" style="display: none">{CHILDREN}</ul>
			{+END}{+END}
		</li>
	{+END}

	{+START,IF,{$NOT,{TOP_LEVEL}}}
		<li class="dropdown-menu-item nlevel {$?,{CURRENT},current,non-current} has-img {$?,{$GET,HAS_CHILDREN},has-children js-mousemove-pop-up-menu}" data-vw-rand="{$GET*,RAND}">
			{+START,IF_NON_EMPTY,{URL}}
			<a {+START,INCLUDE,MENU_LINK_PROPERTIES}{+END} class="dropdown-menu-item-a nlevel-link {$?,{$GET,HAS_CHILDREN},js-click-toggle-sub-menu drawer}" {$?,{$GET,HAS_CHILDREN},data-vw-sub-menu-id="{MENU|*}_dexpand_{$GET*,RAND}"}>{+START,IF_NON_EMPTY,{$GET,img}}<img class="dropdown-menu-item-img" alt="" width="24" height="24" src="{$GET*,img}" />{+END}<span class="dropdown-menu-item-caption">{CAPTION}</span></a>
			{+END}
			{+START,IF_EMPTY,{URL}}
			<a class="dropdown-menu-item-a nlevel-link non-link{$?,{$GET,HAS_CHILDREN},js-click-toggle-sub-menu drawer}" href="#!" {$?,{$GET,HAS_CHILDREN},data-vw-sub-menu-id="{MENU|*}_dexpand_{$GET*,RAND}"}>{+START,IF_NON_EMPTY,{$GET,img}}<img class="dropdown-menu-item-img" alt="" width="24" height="24" src="{$GET*,img}" />{+END}<span class="dropdown-menu-item-caption">{CAPTION}</span></a>
			{+END}
			{+START,IF,{$GET,HAS_CHILDREN}}
				<ul aria-haspopup="true" class="dropdown-menu-items nlevel js-mouseover-set-active-menu js-mouseout-unset-active-menu" id="{MENU|*}_dexpand_{$GET*,RAND}" style="display: none">{CHILDREN}</ul>
			{+END}
		</li>
	{+END}
{+END}{$REPLACE,	,,{$REPLACE,
 +,,{$GET,branch}}}