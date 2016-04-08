function newsletter_preview_into(frame_id,html)
{
	window.setTimeout(function() {
		var adjusted_preview=html.replace(/<!DOCTYPE[^>]*>/i,'').replace(/<html[^>]*>/i,'').replace(/<\/html>/i,'');
		var de=window.frames[frame_id].document.documentElement;
		var body=de.getElementsByTagName('body');
		if (body.length==0)
		{
			set_inner_html(de,adjusted_preview);
		} else
		{
			var head_element=de.getElementsByTagName('head')[0];
			if (!head_element)
			{
				head_element=document.createElement('head');
				de.appendChild(head_element);
			}
			if (de.getElementsByTagName('style').length==0 && adjusted_preview.indexOf('<head')!=-1) /*{$,The conditional is needed for Firefox - for some odd reason it is unable to parse any head tags twice}*/
				set_inner_html(head_element,adjusted_preview.replace(/^(.|\n)*<head[^>]*>((.|\n)*)<\/head>(.|\n)*$/i,'$2'));
			set_inner_html(body[0],adjusted_preview.replace(/^(.|\n)*<body[^>]*>((.|\n)*)<\/body>(.|\n)*$/i,'$2'));
		}

		resize_frame(frame_id,300);
	},500);
	window.setInterval(function() {
		resize_frame(frame_id,300);
	},1000);
}
