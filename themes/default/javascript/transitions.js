"use strict";

if (typeof window.fade_transition_timers=='undefined')
{
	window.fade_transition_timers={};
}

function fade_transition(fade_element,dest_percent_opacity,period_in_msecs,increment,destroy_after)
{
	if (!fade_element) return;

	/*{+START,IF,{$NOT,{$CONFIG_OPTION,enable_animations}}}*/
		set_opacity(fade_element,dest_percent_opacity/100.0);
		return;
	/*{+END}*/

	if (typeof window.fade_transition_timers=='undefined') return;
	if (typeof fade_element.fader_key=='undefined') fade_element.fader_key=fade_element.id+'_'+Math.round(Math.random()*1000000);

	if (window.fade_transition_timers[fade_element.fader_key])
	{
		window.clearTimeout(window.fade_transition_timers[fade_element.fader_key]);
		window.fade_transition_timers[fade_element.fader_key]=null;
	}

	var again;

	if (fade_element.style.opacity)
	{
		var diff=(dest_percent_opacity/100.0)-fade_element.style.opacity;
		var direction=1;
		if (increment>0)
		{
			if (fade_element.style.opacity>dest_percent_opacity/100.0)
			{
				direction=-1;
			}
			var new_increment=Math.min(direction*diff,increment/100.0);
		} else
		{
			if (fade_element.style.opacity<dest_percent_opacity/100.0)
			{
				direction=-1;
			}
			var new_increment=Math.max(direction*diff,increment/100.0);
		}
		var temp=parseFloat(fade_element.style.opacity)+direction*new_increment;
		if (temp<0.0) temp=0.0;
		if (temp>1.0) temp=1.0;
		fade_element.style.opacity=temp;
		again=(Math.round(temp*100)!=Math.round(dest_percent_opacity));
	} else again=true; // Opacity not set yet, need to call back in an event timer

	if (again)
	{
		window.fade_transition_timers[fade_element.fader_key]=window.setTimeout(function() { fade_transition(fade_element,dest_percent_opacity,period_in_msecs,increment,destroy_after); },period_in_msecs);
	} else
	{
		if (destroy_after && fade_element.parentNode) fade_element.parentNode.removeChild(fade_element);
	}
}

