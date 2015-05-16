"use strict";

function choose_page_jump(ob,max,url_stub,message,num_pages)
{
	window.fauxmodal_prompt(
		message,
		num_pages,
		function(res)
		{
			if (res)
			{
				res=parseInt(res);
				if ((res>=1) && (res<=num_pages))
				{
					ob.href=url_stub+((url_stub.indexOf('?')==-1)?'?':'&')+'start='+(max*(res-1));
					click_link(ob);
				}
			}
		},
		'{!JUMP_TO_PAGE;^}'
	);
	return false;
}
