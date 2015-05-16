{$SET,rand,{$RAND}}

<div class="{$,xhtml_substr_no_break Enable if you do not want the grid-style layout }media_set">
	<div id="media_set_{$GET*,rand}">
		{$SET,raw_video,1}
		{MEDIA}
		{$SET,raw_video,0}
	</div>

	{+START,IF,{$CONFIG_OPTION,js_overlays}}
		<script>// <![CDATA[
			var media_set=document.getElementById('media_set_{$GET;/,rand}');
			var as=media_set.querySelectorAll('a,video');

			var contains_video=false;

			var imgs_{$GET%,rand}=[];
			var imgs_thumbs_{$GET%,rand}=[];
			var x=0;
			for (var i=0;i<as.length;i++)
			{
				if (as[i].nodeName.toLowerCase()=='video')
				{
					var span=as[i].getElementsByTagName('span');
					var title='';
					if (span.length!=0)
					{
						title=get_inner_html(span[0]);
						span[0].parentNode.removeChild(span[0]);
					}

					imgs_{$GET%,rand}.push([get_inner_html(as[i]),title,true]);
					imgs_thumbs_{$GET%,rand}.push((as[i].poster && as[i].poster!='')?as[i].poster:'{$IMG;/,video_thumb}');

					contains_video=true;

					x++;
				} else
				{
					if ((as[i].childNodes.length==1) && (as[i].childNodes[0].nodeName.toLowerCase()=='img'))
					{
						as[i].title=as[i].title.replace('{!LINK_NEW_WINDOW;/}','').replace(/^\s+/,'');

						imgs_{$GET%,rand}.push([as[i].href,(as[i].title=='')?as[i].childNodes[0].alt:as[i].title,false]);
						imgs_thumbs_{$GET%,rand}.push(as[i].childNodes[0].src);

						as[i].onclick=function(x) { return function() { open_images_into_lightbox(imgs_{$GET%,rand},x); return false; } }(x);
						if (as[i].rel) as[i].rel=as[i].rel.replace('lightbox','');

						x++;
					}
				}
			}

			// If you only want a single image-based thumbnail
			if (contains_video) {$,Remove this 'if' (so it always runs) if you do not want the grid-style layout (plus remove the media_set class from the outer div)}
			{
				var media_set_html=' \
					<figure class="attachment"{+START,IF_NON_EMPTY,{WIDTH}} style="width: {WIDTH*^/}px"{+END}> \
						<figcaption>'+'{!comcode:MEDIA_SET^/,xxx}'.replace(/xxx/g,imgs_{$GET%,rand}.length)+'<\/figcaption> \
						<div> \
							<div class="attachment_details"> \
								<a onclick="open_images_into_lightbox(imgs_{$GET%,rand}); return false;" target="_blank" title="'+escape_html('{!comcode:MEDIA_SET^/,xxx}'.replace(/xxx/g,imgs_{$GET%,rand}.length))+' {!LINK_NEW_WINDOW^/}" href="#"><img{+START,IF,{$NEQ,{WIDTH}x{HEIGHT},x,{$CONFIG_OPTION,thumb_width}x{$CONFIG_OPTION,thumb_width}}} width="{WIDTH*^/}" height="{HEIGHT*^/}"{+END} src="'+escape_html(imgs_thumbs_{$GET%,rand}[0])+'" /><\/a> \
							<\/div> \
						<\/div> \
					<\/figure>';

				set_inner_html(media_set,media_set_html);
			}
		//]]></script>
	{+END}
</div>
