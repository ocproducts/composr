{+START,SET,branch}
	{$,The line below is just a fudge - we need CHILDREN to evaluate first, so it doesn't interfere with our 'RAND' variable}
	{$SET,HAS_CHILDREN,{$IS_NON_EMPTY,{CHILDREN}}}

	{$SET,RAND,{$RAND}}
	{$SET,img,{$?,{$AND,{$IS_EMPTY,{IMG}},{$LT,{THE_LEVEL},3}},{$IMG,icons/content_types/page},{IMG}}}
	{$SET,img_html,<img class="icon" alt="" src="{$GET*,img}" />}

	{+START,IF,{$PREG_MATCH,^{$BASE_URL}/themes/[^/]+/images(_custom)?/icons/,{$GET,img}}}
		{$SET,img_name,{$PREG_REPLACE,\.(png|gif|svg)$,,{$PREG_REPLACE,^{$BASE_URL}/themes/[^/]+/images(_custom)?/icons/,,{$GET,img}}}}
		{$SET,img_html,{+START,INCLUDE,ICON}NAME={$GET,img_name}{+END}}
	{+END}

	{+START,IF,{TOP_LEVEL}}
		<li class="dropdown-menu-item {$?,{CURRENT},current,non-current}{$?,{$GET,HAS_CHILDREN}, has-children}{+START,IF,{FIRST}} first{+END} toplevel siblings-{SIBLINGS*}{+START,IF,{$GET,HAS_CHILDREN}} js-mousemove-timer-pop-up-menu js-mouseout-clear-pop-up-timer{+END}" data-vw-rand="{$GET*,RAND}">
			<a {+START,INCLUDE,MENU_LINK_PROPERTIES}{+END} class="dropdown-menu-item-a {+START,IF_EMPTY,{URL}}non-link {+END}toplevel-link{+START,IF,{LAST}} last{+END}{+START,IF,{FIRST}} first{+END} {$?,{$GET,HAS_CHILDREN},js-focus-pop-up-menu js-click-unset-active-menu js-click-toggle-sub-menu}"{$?,{$GET,HAS_CHILDREN}, data-vw-sub-menu-id="{MENU|*}-dexpand-{$GET*,RAND}"}>
				{+START,IF_NON_EMPTY,{$GET,img}}<span class="dropdown-menu-item-icon">{$GET,img_html}</span>{+END}
				<span class="dropdown-menu-item-caption">{CAPTION}</span>
			</a>
			{+START,IF,{$GET,HAS_CHILDREN}}{+START,IF,{$DESKTOP}}
				<ul aria-haspopup="true" class="dropdown-menu-items nlevel js-mouseover-set-active-menu js-mouseout-unset-active-menu" id="{MENU|*}-dexpand-{$GET*,RAND}" style="display: none">
					{CHILDREN}
				</ul>
			{+END}{+END}
		</li>
	{+END}

	{+START,IF,{$NOT,{TOP_LEVEL}}}
		<li class="dropdown-menu-item nlevel {$?,{CURRENT},current,non-current} has-img {$?,{$GET,HAS_CHILDREN},has-children js-mousemove-pop-up-menu}" data-vw-rand="{$GET*,RAND}">
			<a {+START,IF_NON_EMPTY,{URL}}{+START,INCLUDE,MENU_LINK_PROPERTIES}{+END}{+END} {+START,IF_EMPTY,{URL}}href="#!"{+END} class="dropdown-menu-item-a nlevel-link {+START,IF_EMPTY,{URL}}non-link{+END} {$?,{$GET,HAS_CHILDREN},js-click-toggle-sub-menu drawer}" {$?,{$GET,HAS_CHILDREN}, data-vw-sub-menu-id="{MENU|*}-dexpand-{$GET*,RAND}"}>
				{+START,IF_NON_EMPTY,{$GET,img}}<span class="dropdown-menu-item-icon">{$GET,img_html}</span>{+END}
				<span class="dropdown-menu-item-caption">{CAPTION}</span>
			</a>

			{+START,IF,{$GET,HAS_CHILDREN}}
				<ul aria-haspopup="true" class="dropdown-menu-items nlevel js-mouseover-set-active-menu js-mouseout-unset-active-menu" id="{MENU|*}-dexpand-{$GET*,RAND}" style="display: none">{CHILDREN}</ul>
			{+END}
		</li>
	{+END}
{+END}{$REPLACE,	,,{$REPLACE,
 +,,{$GET,branch}}}