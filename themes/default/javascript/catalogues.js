"use strict";

function catalogue_field_change_watching()
{
	// Find all our ordering fields
	var s=document.getElementsByTagName('select');
	var all_orderers=[];
	for (var i=0;i<s.length;i++)
	{
		if (s[i].name.indexOf('order')!=-1)
		{
			all_orderers.push(s[i]);
		}
	}
	// Assign generated change function to all ordering fields (generated so as to avoid JS late binding problem)
	for (var i=0;i<all_orderers.length;i++)
	{
		all_orderers[i].onchange=catalogue_field_reindex_around(all_orderers,all_orderers[i]);
	}
}

function catalogue_field_reindex_around(all_orderers,ob)
{
	return function() {
		var next_index=0;

		// Sort our all_orderers array by selectedIndex
		for (var i=0;i<all_orderers.length;i++)
		{
			for (var j=i+1;j<all_orderers.length;j++)
			{
				if (all_orderers[j].selectedIndex<all_orderers[i].selectedIndex)
				{
					var temp=all_orderers[i];
					all_orderers[i]=all_orderers[j];
					all_orderers[j]=temp;
				}
			}
		}

		// Go through all fields, assigning them the order (into selectedIndex). We are reordering *around* the field that has just had it's order set.
		for (var i=0;i<all_orderers.length;i++)
		{
			if (next_index==ob.selectedIndex) next_index++;

			if (all_orderers[i]!=ob)
			{
				all_orderers[i].selectedIndex=next_index;
				next_index++;
			}
		}
	}
}
