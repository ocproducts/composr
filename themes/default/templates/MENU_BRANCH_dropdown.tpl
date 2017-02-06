{+START,SET,branch}
	{$,The line below is just a fudge - we need CHILDREN to evaluate first, so it doesn't interfere with our 'RAND' variable}
	{$SET,HAS_CHILDREN,{$IS_NON_EMPTY,{CHILDREN}}}

	{$SET,RAND,{$RAND}}

	{$SET,img,{$?,{$AND,{$IS_EMPTY,{IMG}},{$LT,{THE_LEVEL},3}},{$IMG,icons/24x24/menu/_generic_spare/page},{IMG}}}
	{$SET,img_2x,{$?,{$AND,{$IS_EMPTY,{IMG_2X}},{$LT,{THE_LEVEL},3}},{$IMG,icons/48x48/menu/_generic_spare/page},{IMG_2X}}}

	{+START,IF,{TOP_LEVEL}}
		<li class="{$?,{CURRENT},current,non_current}{+START,IF,{$GET,HAS_CHILDREN}} has_children{+END}{+START,IF,{$AND,{$NOT,{$GET,HAS_CHILDREN}},{LAST}}} last{+END}{+START,IF,{FIRST}} first{+END} toplevel {+START,IF,{$GET,HAS_CHILDREN}}{+START,IF,{$NOT,{$MOBILE}}}js-mousemove-timer-pop-up-menu js-mouseout-clear-pop-up-timer{+END}{+END}" data-vw-rand="{$GET*,RAND}">
			<a {+START,INCLUDE,MENU_LINK_PROPERTIES}{+END} class="{+START,IF_EMPTY,{URL}}non_link {+END}toplevel_link{+START,IF,{LAST}} last{+END}{+START,IF,{FIRST}} first{+END} {$?,{$GET,HAS_CHILDREN},js-focus-pop-up-menu js-click-unset-active-menu}" data-vw-rand="{$GET*,RAND}">
				{+START,IF_NON_EMPTY,{$GET,img}}<img width="20" height="20" alt="" src="{$GET*,img}" srcset="{$GET*,img_2x} 2x" /> {+END}<span>{CAPTION}</span></a>
			{+START,IF,{$GET,HAS_CHILDREN}}{+START,IF,{$NOT,{$MOBILE}}}
				<ul aria-haspopup="true" class="nlevel js-mouseover-set-active-menu js-mouseout-unset-active-menu" id="{MENU|*}_dexpand_{$GET*,RAND}" style="display: none">{CHILDREN}</ul>
			{+END}{+END}
		</li>
	{+END}

	{+START,IF,{$NOT,{TOP_LEVEL}}}
		<li class="nlevel {$?,{CURRENT},current,non_current} has_img {$?,{$GET,HAS_CHILDREN},js-mousemove-pop-up-menu}" data-vw-rand="{$GET*,RAND}" data-click-forward="a">
			{+START,IF_NON_EMPTY,{$GET,img}}<img alt="" src="{$GET*,img}" srcset="{$GET*,img_2x} 2x" />{+END}
			{+START,IF_NON_EMPTY,{URL}}
				<a {+START,INCLUDE,MENU_LINK_PROPERTIES}{+END} {+START,IF,{$GET,HAS_CHILDREN}} class="drawer"{+END}>{CAPTION}</a>{+START,IF,{$GET,HAS_CHILDREN}}&nbsp;<span>&rarr;</span>{+END}
			{+END}
			{+START,IF_EMPTY,{URL}}
				<a class="non_link{+START,IF,{$GET,HAS_CHILDREN}} drawer{+END}" href="#!">{CAPTION}</a>{+START,IF,{$GET,HAS_CHILDREN}}&nbsp;<span>&rarr;</span>{+END}
			{+END}
			{+START,IF,{$GET,HAS_CHILDREN}}
				<ul aria-haspopup="true" class="nlevel js-mouseover-set-active-menu js-mouseout-unset-active-menu" id="{MENU|*}_dexpand_{$GET*,RAND}" style="display: none">{CHILDREN}</ul>
			{+END}
		</li>
	{+END}
{+END}{$REPLACE,	,,{$REPLACE,
 +,,{$GET,branch}}}