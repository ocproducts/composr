{$,The line below is just a fudge - we need CHILDREN to evaluate first, so it doesn't interfere with our 'RAND' variable}
{$SET,HAS_CHILDREN,{$IS_NON_EMPTY,{CHILDREN}}}

{$SET,RAND,{$RAND}}

<li data-view="PopupMenuBranch" data-view-params="{+START,PARAMS_JSON,MENU,RAND,HAS_CHILDREN}{_*}{+END}" class="{$?,{CURRENT},current,non_current} {$?,{$IS_EMPTY,{IMG}},has_no_img,has-img} {$?,{$GET,HAS_CHILDREN},js-mousemove-pop-up-menu}">
	{+START,IF_NON_EMPTY,{IMG}}<img alt="" src="{IMG*}" srcset="{IMG_2X*} 2x" />{+END}

	{+START,IF_NON_EMPTY,{URL}}
		<a {+START,INCLUDE,MENU_LINK_PROPERTIES}{+END}{+START,IF,{$GET,HAS_CHILDREN}} class="drawer js-click-unset-active-menu js-focus-pop-up-menu"{+END}>{CAPTION}</a>
	{+END}
	{+START,IF_EMPTY,{URL}}
		<a class="non-link{+START,IF,{$GET,HAS_CHILDREN}} drawer js-click-unset-active-menu js-focus-pop-up-menu{+END}" href="#!">{CAPTION}</a>
	{+END}
	{+START,IF,{$GET,HAS_CHILDREN}}
		<ul aria-haspopup="true" class="nlevel js-mouseout-unset-active-menu js-mouseover-set-active-menu" id="{MENU|*}_pexpand_{$GET*,RAND}" style="display: none">
			{CHILDREN}
		</ul>
	{+END}
</li>