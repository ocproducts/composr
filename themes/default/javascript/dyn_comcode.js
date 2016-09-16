"use strict";

function accordion(e)
{
	var i,nodes=get_elements_by_class_name(e.parentNode.parentNode,'toggleable_tray');
	for (i=0;i<nodes.length;i++)
	{
		if ((nodes[i].parentNode!=e) && (nodes[i].style.display!='none') && (nodes[i].parentNode.className.indexOf('accordion_trayitem')!=-1))
		{
			toggleable_tray(nodes[i].parentNode,true);
		}
	}
	return toggleable_tray(e);
}

// ======================
// main_image_fader block
// ======================

function initialise_image_fader(data,id)
{
	data.fp_animation=document.getElementById('image_fader_'+id);
	data.fp_animation_fader=document.createElement('img');
	data.tease_title=document.getElementById('image_fader_title_'+id);
	data.tease_scrolling_text=document.getElementById('image_fader_scrolling_text_'+id);
	data.fp_animation_fader.className='img_thumb';
	data.fp_animation.parentNode.insertBefore(data.fp_animation_fader,data.fp_animation);
	data.fp_animation.parentNode.style.position='relative';
	data.fp_animation.parentNode.style.display='block';
	data.fp_animation_fader.style.position='absolute';
	data.fp_animation_fader.src='{$IMG;,blank}'.replace(/^https?:/,window.location.protocol);
}

function initialise_image_fader_title(data,v,k)
{
	data['title'+k]=v;
	if (k==0)
	{
		if (data.tease_title)
		{
			set_inner_html(data.tease_title,data['title'+k]);
		}
	}
}

function initialise_image_fader_html(data,v,k)
{
	data['html'+k]=v;
	if (k==0)
	{
		if (data.tease_scrolling_text)
		{
			set_inner_html(data.tease_scrolling_text,(data['html'+k]=='')?'{!MEDIA;^}':data['html'+k]);
		}
	}
}

function initialise_image_fader_image(data,v,k,mill,total)
{
	var period_in_msecs=50;
	var increment=3;
	if (period_in_msecs*100/increment>mill)
	{
		period_in_msecs=mill*increment/100;
		period_in_msecs*=0.9; // A little give
	}

	data['url'+k]=v;
	new Image().src=data['url'+k]; // precache
	window.setTimeout(function() {
		var func=function() {
			data.fp_animation_fader.src=data.fp_animation.src;
			set_opacity(data.fp_animation_fader,1.0);
			fade_transition(data.fp_animation_fader,0,period_in_msecs,increment*-1);
			set_opacity(data.fp_animation,0.0);
			fade_transition(data.fp_animation,100,period_in_msecs,increment);
			data.fp_animation.src=data['url'+k];
			data.fp_animation_fader.style.left=((find_width(data.fp_animation_fader.parentNode)-find_width(data.fp_animation_fader))/2)+'px';
			data.fp_animation_fader.style.top=((find_height(data.fp_animation_fader.parentNode)-find_height(data.fp_animation_fader))/2)+'px';
			if (data.tease_title)
			{
				set_inner_html(data.tease_title,data['title'+k]);
			}
			if (data.tease_scrolling_text)
			{
				set_inner_html(data.tease_scrolling_text,data['html'+k]);
			}
		};
		if (k!=0) func();
		window.setInterval(func,mill*total);
	},k*mill);
}

// =======
// COMCODE
// =======

function big_tabs_init()
{
	/* Precache images */
	new Image().src='{$IMG;,big_tabs_controller_button}'.replace(/^https?:/,window.location.protocol);
	new Image().src='{$IMG;,big_tabs_controller_button_active}'.replace(/^https?:/,window.location.protocol);
	new Image().src='{$IMG;,big_tabs_controller_button_top_active}'.replace(/^https?:/,window.location.protocol);
	new Image().src='{$IMG;,big_tabs_controller_button_top}'.replace(/^https?:/,window.location.protocol);
}

function countdown(id,direction,tailing)
{
	var countdown=document.getElementById(id);
	var inside=get_inner_html(countdown);
	var multiples=[];
	if (tailing>=4) multiples.push(365);
	if (tailing>=3) multiples.push(24);
	if (tailing>=2) multiples.push(60);
	if (tailing>=1) multiples.push(60);
	multiples.push(1);
	var us=inside.match(/\d+/g);
	var total=0,multiplier=1;
	while (multiples.length>us.length)
	{
		us.push('0');
	}
	for (var i=us.length-1;i>=0;i--)
	{
		multiplier*=multiples[i];
		total+=window.parseInt(us[i])*multiplier;
	}

	if (total>0)
	{
		total+=direction;
		inside=inside.replace(/\d+/g,'!!!');
		if (total==0)
		{
			countdown.className='red_alert';
			//countdown.style.textDecoration='blink';
		}
		for (var i=0;i<us.length;i++)
		{
			us[i]=Math.floor(total/multiplier);
			total-=us[i]*multiplier;
			multiplier/=multiples[i];
			inside=inside.replace('!!!',us[i]);
		}
		set_inner_html(countdown,inside);
	}
}

function initialise_carousel(id)
{
	var carousel=document.getElementById('carousel_'+id);
	var main=get_elements_by_class_name(carousel,'main')[0];
	var carousel_ns=document.getElementById('carousel_ns_'+id);
	carousel_ns.parentNode.removeChild(carousel_ns);
	main.appendChild(carousel_ns);
	carousel.style.display='block';

	add_event_listener_abstract(window,'real_load',function() {
		var h=find_height(main)+'px';
		get_elements_by_class_name(carousel,'move_left')[0].style.height=h;
		get_elements_by_class_name(carousel,'move_right')[0].style.height=h;

		_create_faders(main);
		_update_faders(main);
	});
}

function carousel_move(id,amount)
{
	var carousel=document.getElementById('carousel_'+id);

	window.setTimeout(function() { _carousel_move(carousel,amount); },10);
}

function _carousel_move(carousel,amount)
{
	var main=get_elements_by_class_name(carousel,'main')[0];

	if (amount>0)
	{
		main.scrollLeft+=3;
		amount--;
		if (amount<0) amount=0;
	} else
	{
		main.scrollLeft-=3;
		amount++;
		if (amount>0) amount=0;
	}

	_update_faders(main);

	if (amount!=0)
		window.setTimeout(function() { _carousel_move(carousel,amount); },10);
}

function _create_faders(main)
{
	var left=document.createElement('img');
	left.setAttribute('src','{$IMG;,carousel/fade_left}');
	left.style.position='absolute';
	left.style.left='43px';
	left.style.top='0';
	main.parentNode.appendChild(left);

	var right=document.createElement('img');
	right.setAttribute('src','{$IMG;,carousel/fade_right}');
	right.style.position='absolute';
	right.style.right='43px';
	right.style.top='0';
	main.parentNode.appendChild(right);
}

function _update_faders(main)
{
	var imgs=main.parentNode.getElementsByTagName('img');

	var left=imgs[imgs.length-2];
	var right=imgs[imgs.length-1];

	if (left.style.position=='absolute') // Check it really is a fader (stops bugs in other areas making bigger weirdness)
		left.style.visibility=(main.scrollLeft==0)?'hidden':'visible';
	if (right.style.position=='absolute') // Ditto
		right.style.visibility=(main.scrollLeft+find_width(main)>=main.scrollWidth-1)?'hidden':'visible';
}

function flip_page(to,pass_id,sections)
{
	var i,current_pos=0,section;

	if (window['big_tabs_auto_cycler_'+pass_id])
	{
		window.clearTimeout(window['big_tabs_auto_cycler_'+pass_id]);
		window['big_tabs_auto_cycler_'+pass_id]=null;
	}

	if (typeof to=='number')
	{
		for (i=0;i<sections.length;i++)
		{
			section=document.getElementById(pass_id+'_section_'+sections[i]);
			if (section)
			{
				if ((section.style.display=='block') && (section.style.position!='absolute'))
				{
					current_pos=i;
					break;
				}
			}
		}

		current_pos+=to;
	} else
	{
		for (i=0;i<sections.length;i++)
		{
			if (sections[i]==to)
			{
				current_pos=i;
				break;
			}
		}
	}

	// Previous/next updates
	var x;
	x=document.getElementById(pass_id+'_has_next_yes');
	if (x) x.style.display=(current_pos==sections.length-1)?'none':'inline-block';
	x=document.getElementById(pass_id+'_has_next_no');
	if (x) x.style.display=(current_pos==sections.length-1)?'inline-block':'none';
	x=document.getElementById(pass_id+'_has_previous_yes');
	if (x) x.style.display=(current_pos==0)?'none':'inline-block';
	x=document.getElementById(pass_id+'_has_previous_no');
	if (x) x.style.display=(current_pos==0)?'inline-block':'none';

	// We make our forthcoming one instantly visible to stop Google Chrome possibly scrolling up if there is a tiny time interval when none are visible
	x=document.getElementById(pass_id+'_section_'+sections[i]);
	if (x) x.style.display='block';

	for (i=0;i<sections.length;i++)
	{
		x=document.getElementById(pass_id+'_goto_'+sections[i]);
		if (x) x.style.display=(i==current_pos)?'none':'inline-block';
		x=document.getElementById(pass_id+'_btgoto_'+sections[i]);
		if (x) x.className=x.className.replace(/big\_tab\_(in)?active/,(i==current_pos)?'big_tab_active':'big_tab_inactive');
		x=document.getElementById(pass_id+'_isat_'+sections[i]);
		if (x) x.style.display=(i==current_pos)?'inline-block':'none';
		x=document.getElementById(pass_id+'_section_'+sections[i]);
		var current_place=document.getElementById(pass_id+'_section_'+sections[current_pos]);
		//var width=current_place?'100%':null;
		var width=current_place?find_width(current_place,true):null;
		if (x)
		{
			if (x.className=='comcode_big_tab')
			{
				if (i==current_pos)
				{
					if ((typeof x.fader_key!='undefined') && (window.fade_transition_timers[x.fader_key]))
					{
						window.clearTimeout(window.fade_transition_timers[x.fader_key]);
						window.fade_transition_timers[x.fader_key]=null;
					}

					x.style.width='';
					x.style.position='static';
					x.style.zIndex=10;
					set_opacity(x,1.0);
				} else
				{
					if (x.style.position!='static') set_opacity(x,0.0); else set_opacity(x,1.0);
					if ((typeof x.fader_key=='undefined') || (!window.fade_transition_timers[x.fader_key]))
						fade_transition(x,0,30,-5);
					x.style.width=(find_width(x)-24)+'px'; // 24=lhs padding+rhs padding+lhs border+rhs border
					x.style.position='absolute';
					x.style.zIndex=-10;
					x.style.top='0';
					x.parentNode.style.position='relative';
				}
				x.style.display='block';
				//x.style.width=width+'px';
			} else
			{
				x.style.display=(i==current_pos)?'block':'none';

				if ((typeof window.fade_transition!='undefined') && (i==current_pos))
				{
					set_opacity(x,0.0);
					fade_transition(x,100,30,4);
				}
			}
		}
	}

	if (window['move_between_big_tabs_'+pass_id])
	{
		window['big_tabs_auto_cycler_'+pass_id]=window.setInterval(window['move_between_big_tabs_'+pass_id], window['big_tabs_switch_time_'+pass_id]);
	}

	return false;
}

function shocker_tick(id,time,min_color,max_color)
{
	if ((typeof document.hidden!='undefined') && (document.hidden)) return;

	if (window.shocker_pos[id]==window.shocker_parts[id].length-1) window.shocker_pos[id]=0;
	var e_left=document.getElementById('comcodeshocker'+id+'_left');
	if (!e_left) return;
	set_inner_html(e_left,window.shocker_parts[id][window.shocker_pos[id]][0]);
	set_opacity(e_left,0.6);
	if (typeof window.fade_transition!='undefined')
	{
		set_opacity(e_left,0.0);
		fade_transition(e_left,100,time/40,5);
	}
	var e_right=document.getElementById('comcodeshocker'+id+'_right');
	if (!e_right) return;
	set_inner_html(e_right,window.shocker_parts[id][window.shocker_pos[id]][1]);
	set_opacity(e_right,0);
	if (typeof window.fade_transition!='undefined')
	{
		set_opacity(e_right,0.0);
		fade_transition(e_right,100,time/20,5);
	}
	window.shocker_pos[id]++;

	window['comcodeshocker'+id+'_left']=[0,min_color,max_color,time/13,[]];
	window.setInterval(function() { process_wave(e_left); },window['comcodeshocker'+id+'_left'][3]);
}

if (typeof window.ticker_tick=='undefined')
{
	window.tick_pos=[];
}
function ticker_tick(id,width)
{
	if ((typeof document.hidden!='undefined') && (document.hidden)) return;

	if (!window.focused) return;

	var e=document.getElementById(id);
	if (!e) return;
	if (e.mouseisover) return;
	e.style.textIndent=window.tick_pos[id]+'px';
	window.tick_pos[id]--;
	if (window.tick_pos[id]<-1.1*find_width(e.childNodes[0])) window.tick_pos[id]=width;
}

if (typeof window.jumper_pos=='undefined')
{
	window.jumper_pos=[];
	window.jumper_parts=[];
}
function jumper_tick(id)
{
	if ((typeof document.hidden!='undefined') && (document.hidden)) return;

	if (window.jumper_pos[id]==window.jumper_parts[id].length-1) window.jumper_pos[id]=0;
	var e=document.getElementById(id);
	if (!e) return;
	set_inner_html(e,window.jumper_parts[id][window.jumper_pos[id]]);
	window.jumper_pos[id]++;
}

function crazy_tick()
{
	if (typeof window.mouse_x=='undefined') return;
	if (typeof window.mouse_y=='undefined') return;

	register_mouse_listener();

	var e,i,s_width,biasx,biasy;
	for (i=0;i<window.crazy_criters.length;i++)
	{
		e=document.getElementById(window.crazy_criters[i]);
		s_width=e.clientWidth;

		biasx=window.mouse_x-e.offsetLeft;
		if (biasx>0) biasx=2; else biasx=-1;
		if (Math.random()*4<1) biasx=0;
		biasy=window.mouse_y-e.offsetTop;
		if (biasy>0) biasy=2; else biasy=-1;
		if (Math.random()*4<1) biasy=0;

		if (s_width<100)
			e.style.width=(s_width+1)+'px';
		e.style.left=(e.offsetLeft+(Math.random()*2-1+biasx)*30)+'px';
		e.style.top=(e.offsetTop+(Math.random()*2-1+biasy)*30)+'px';
		e.style.position='absolute';
	}
}

