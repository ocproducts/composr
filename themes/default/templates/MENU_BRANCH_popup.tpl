{$,The line below is just a fudge - we need CHILDREN to evaluate first, so it doesn't interfere with our 'RAND' variable}
{$SET,HAS_CHILDREN,{$IS_NON_EMPTY,{CHILDREN}}}

{$SET,RAND,{$RAND}}

<li{+START,IF,{$GET,HAS_CHILDREN}} onmousemove="return pop_up_menu('{MENU|;*}_pexpand_{$GET;*,RAND}',null,'{MENU|;*}_p');"{+END} class="{$?,{CURRENT},current,non_current} {$?,{$IS_EMPTY,{IMG}},has_no_img,has_img}">
	{+START,IF_NON_EMPTY,{IMG}}<img alt="" src="{IMG*}" srcset="{IMG_2X*} 2x" />{+END}
	{+START,IF_NON_EMPTY,{URL}}
		<a{+START,INCLUDE,MENU_LINK_PROPERTIES}{+END}{+START,IF,{$GET,HAS_CHILDREN}} class="drawer" onclick="deset_active_menu();" onfocus="return pop_up_menu('{MENU|;*}_pexpand_{$GET;*,RAND}',null,'{MENU|;*}_p');"{+END}>{CAPTION}</a>
	{+END}
	{+START,IF_EMPTY,{URL}}
		<a class="non_link{+START,IF,{$GET,HAS_CHILDREN}} drawer{+END}" onclick="{+START,IF,{$GET,HAS_CHILDREN}}deset_active_menu(); {+END}return false;" href="#"{+START,IF,{$GET,HAS_CHILDREN}} onfocus="return pop_up_menu('{MENU|;*}_pexpand_{$GET;*,RAND}',null,'{MENU|;*}_p');"{+END}>{CAPTION}</a>
	{+END}
	{+START,IF,{$GET,HAS_CHILDREN}}
		<ul aria-haspopup="true" class="nlevel" onmouseover="if (active_menu==null) return set_active_menu(this.id,'{MENU|;*}_p'); else return false;" onmouseout="return deset_active_menu();" id="{MENU|*}_pexpand_{$GET*,RAND}" style="display: none">
			{CHILDREN}
		</ul>
	{+END}
</li>

