{$SET,js_menu,{$NOT,{$BROWSER_MATCHES,bot}}}{+START,IF,{$NOT,{$GET,js_menu}}}
	<li class="{$?,{CURRENT},current,non_current} {$?,{$IS_EMPTY,{IMG}},has_no_img,has_img}">
		<span>
			{+START,IF_NON_EMPTY,{IMG}}<img alt="" src="{IMG*}" srcset="{IMG_2X*} 2x" />{+END}
			{+START,IF_NON_EMPTY,{URL}}
				<a {+START,IF_NON_EMPTY,{TOOLTIP}} title="{$STRIP_TAGS,{CAPTION}}{+START,IF_NON_EMPTY,{TOOLTIP}}: {TOOLTIP*}{+END}"{+END} href="{URL*}">{CAPTION}</a>
			{+END}
			{+START,IF_EMPTY,{URL}}
				<span>{CAPTION}</span>
			{+END}
		</span>
		{+START,IF_NON_EMPTY,{CHILDREN}}
			<ul class="toggleable_tray">
				{CHILDREN}
			</ul>
		{+END}
	</li>
{+END}
{+START,IF,{$GET,js_menu}}{$?,{FIRST},[}{"caption": {$JSON_ENCODE,{CAPTION}}, "tooltip": {$JSON_ENCODE,{TOOLTIP}}, "url": {$JSON_ENCODE,{URL}}, "img": {$JSON_ENCODE,{IMG}}, "img_2x": {$JSON_ENCODE,{IMG_2X}}, "current": {$?,{CURRENT},true,false}, "children": {$?,{$IS_EMPTY,{CHILDREN}},[],{$TRIM,{CHILDREN}}}}{$?,{LAST},],\,}{+END}