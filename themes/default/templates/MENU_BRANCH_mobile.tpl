{$,The line below is just a fudge - we need CHILDREN to evaluate first, so it doesn't interfere with our 'RAND' variable}
{$SET,HAS_CHILDREN,{$IS_NON_EMPTY,{CHILDREN}}}

{$SET,RAND,{$RAND}}

{$SET,img,{$?,{$AND,{$IS_EMPTY,{IMG}},{$LT,{THE_LEVEL},3}},{$IMG,icons/24x24/menu/_generic_spare/page},{IMG}}}
{$SET,img_2x,{$?,{$AND,{$IS_EMPTY,{IMG_2X}},{$LT,{THE_LEVEL},3}},{$IMG,icons/48x48/menu/_generic_spare/page},{IMG_2X}}}

<li class="{$?,{CURRENT},current,non_current} {$?,{$IS_EMPTY,{$GET,img}},has_no_img,has_img}">
	<a class="{+START,IF_EMPTY,{URL}}non_link {+END}{+START,IF,{$GET,HAS_CHILDREN}} drawer{+END}"{+START,IF,{$GET,HAS_CHILDREN}} onclick="return show_mobile_sub_menu(this,'{MENU|*}_pexpand_{$GET;*,RAND}','{URL;*}');"{+END} href="{$?*,{$IS_EMPTY,{URL}},#,{URL}}">{+START,IF_NON_EMPTY,{$GET,img}}<img alt="" src="{$GET*,img}" srcset="{$GET*,img_2x} 2x" /> {+END}{CAPTION}</a>
	{+START,IF,{$GET,HAS_CHILDREN}}
		<ul aria-haspopup="true" class="nlevel" id="{MENU|*}_pexpand_{$GET*,RAND}" style="display: none">
			{CHILDREN}
		</ul>
	{+END}
</li>

