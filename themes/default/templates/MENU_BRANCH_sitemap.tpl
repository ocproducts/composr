{$SET,js_menu,{$NOT,{$BROWSER_MATCHES,bot}}}
{$SET,img,{$?,{$AND,{$IS_EMPTY,{IMG}},{$LT,{THE_LEVEL},3}},{$IMG,icons/24x24/menu/_generic_spare/page},{IMG}}}
{$SET,img_2x,{$?,{$AND,{$IS_EMPTY,{IMG_2X}},{$LT,{THE_LEVEL},3}},{$IMG,icons/48x48/menu/_generic_spare/page},{IMG_2X}}}
{+START,IF,{$NOT,{$GET,js_menu}}}
	<li class="{$?,{CURRENT},current,non_current} has_img">
		<span>
			<img alt="" src="{$GET*,img}" srcset="{$GET*,img_2x} 2x" />
			{+START,IF_NON_EMPTY,{URL}}
				<a {+START,IF_NON_EMPTY,{TOOLTIP}} title="{$STRIP_TAGS,{CAPTION}}{+START,IF_NON_EMPTY,{TOOLTIP}}: {TOOLTIP*}{+END}"{+END} href="{URL*}">{CAPTION}</a>
			{+END}
			{+START,IF_EMPTY,{URL}}
				<span>{CAPTION}</span>
			{+END}
		</span>
		{+START,IF_NON_EMPTY,{CHILDREN}}
			<ul class="toggleable-tray">
				{CHILDREN}
			</ul>
		{+END}
	</li>
{+END}
{+START,IF,{$GET,js_menu}}{$?,{FIRST},[}{"caption": {$JSON_ENCODE,{CAPTION}}, "tooltip": {$JSON_ENCODE,{TOOLTIP}}, "url": {$JSON_ENCODE,{URL}}, "img": {$JSON_ENCODE,{$GET,img}}, "img_2x": {$JSON_ENCODE,{$GET,img_2x}}, "current": {$?,{CURRENT},true,false}, "children": {$?,{$IS_EMPTY,{CHILDREN}},[],{$TRIM,{CHILDREN}}}}{$?,{LAST},],\,}{+END}
