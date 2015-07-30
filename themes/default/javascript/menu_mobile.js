function mobile_menu_button(id)
{
	var branch=document.getElementById('r_'+id+'_d');
	if (!branch) return true;
	var ob=branch.parentNode;
	if (ob.style.display=='none')
	{
		ob.style.display='block';
	} else
	{
		ob.style.display='none';
	}
	return false;
}

function show_mobile_sub_menu(ob,sub_id,url)
{
	var sub=document.getElementById(sub_id);
	if (sub.style.display=='none')
	{
		sub.style.display='block';
	} else
	{
		if (url!='') return true; // Second click goes to it
		sub.style.display='none';
	}
	return false;
}
