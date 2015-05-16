"use strict";

// ==============================
// DYNAMIC TREE CREATION FUNCTION
// ==============================

function generate_menu_sitemap(save_to,structure,the_level)
{
	var target=document.getElementById(save_to);

	if (the_level==0)
	{
		set_inner_html(target,'');

		var ul=document.createElement('ul');

		target.appendChild(ul);

		target=ul;
	}

	var node;
	for (var i=0;i<structure.length;i++)
	{
		node=structure[i];

		_generate_menu_sitemap(target,node,the_level);
	}
}

function _generate_menu_sitemap(target,node,the_level)
{
	var li=document.createElement('li');
	li.className=node.current?'current':'non_current';
	li.className+=' '+((node.img=='')?'has_no_img':'has_img');
	li.id='sitemap_menu_branch_'+Math.round(Math.random()*100000000000);

	var span=document.createElement('span');
	li.appendChild(span);

	if (node.img!='')
	{
		var img=document.createElement('img');
		img.src=node.img;
		img.srcset=node.img_2x+' 2x';
		span.appendChild(img);
		span.appendChild(document.createTextNode(' '));
	}

	var a=document.createElement((node.url=='')?'span':'a');
	if (node.url!='')
	{
		if (node.tooltip!='') a.title=node.caption+': '+node.tooltip;
		a.href=node.url;
	}
	span.appendChild(a);
	set_inner_html(a,node.caption);

	target.appendChild(li);

	if (node.children.length!=0)
	{
		var ul=document.createElement('ul');

		// Show expand icon...

		span.appendChild(document.createTextNode(' '));

		var expand=document.createElement('a');
		expand.className='toggleable_tray_button';
		expand.href='#';
		expand.onclick=function() { return toggleable_tray(li); };

		var expand_img=document.createElement('img');
		if (the_level<2) // High-levels start expanded
		{
			expand_img.alt="{!CONTRACT^#}";
			expand_img.src="{$IMG#,1x/trays/contract}".replace(/^https?:/,window.location.protocol);
			expand_img.srcset="{$IMG#,2x/trays/contract}".replace(/^https?:/,window.location.protocol)+' 2x';
		} else
		{
			expand_img.alt="{!EXPAND^#}";
			expand_img.src="{$IMG#,1x/trays/expand}".replace(/^https?:/,window.location.protocol);
			expand_img.srcset="{$IMG#,2x/trays/expand}".replace(/^https?:/,window.location.protocol)+' 2x';
			ul.style.display='none';
		}
		expand.appendChild(expand_img);

		span.appendChild(expand);

		// Show children...

		ul.id='sitemap_menu_children_'+Math.round(Math.random()*100000000000);
		ul.className='toggleable_tray';
		li.appendChild(ul);
		generate_menu_sitemap(ul.id,node.children,the_level+1);
	}
}
