<script src="https://www.google.com/jsapi"></script>
{+START,IF,{CLUSTER}}
	<script src="https://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclustererplus/src/markerclusterer_packed.js"></script>
{+END}
<script>// <![CDATA[
	if (typeof window.data_map=='undefined') window.data_map=null;
	function google_map_initialize()
	{
		var bounds=new google.maps.LatLngBounds();
		var specified_center=new google.maps.LatLng({$?,{$IS_EMPTY,{LATITUDE}},0.0,{LATITUDE`}},{$?,{$IS_EMPTY,{LONGITUDE}},0.0,{LONGITUDE`}});
		window.data_map=new google.maps.Map(document.getElementById('{DIV_ID;/}'),
		{
			zoom: {ZOOM%},
			{+START,IF,{$NOT,{CENTER}}} {$,NB: the block center parameter means to autofit the contents cleanly; if the parameter is not set it will center about the given latitude/longitude}
				center: specified_center,
			{+END}
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			overviewMapControl: true,
			overviewMapControlOptions:
			{
				opened: true
			}
		});

		var info_window=new google.maps.InfoWindow();

		{$,Close InfoWindow when clicking anywhere on the map.}
		google.maps.event.addListener(data_map,'click',function ()
		{
			info_window.close();
		});

		var data=[
			{+START,LOOP,DATA}
				{+START,IF,{$NEQ,{_loop_key},0}},{+END}
				['{ENTRY_TITLE;^/}',{LATITUDE`},{LONGITUDE`},{CC_ID%},{ID%},'{ENTRY_CONTENT;^/}',{STAR%}]
			{+END}
		];

		{$,Show markers}
		var latLng,marker_options,marker;
		var bound_length=0;
		{+START,IF,{CLUSTER}}
		var markers=[];
		{+END}
		{+START,IF,{$AND,{$NEQ,{MIN_LATITUDE},{MAX_LATITUDE}},{$NEQ,{MIN_LONGITUDE},{MAX_LONGITUDE}}}}
			{+START,IF_NON_EMPTY,{MIN_LATITUDE}{MIN_LONGITUDE}}
				latLng=new google.maps.LatLng({MIN_LATITUDE`},{MIN_LONGITUDE`});
				bounds.extend(latLng);
				bound_length++;
			{+END}
			{+START,IF_NON_EMPTY,{MAX_LATITUDE}{MAX_LONGITUDE}}
				latLng=new google.maps.LatLng({MAX_LATITUDE`},{MAX_LONGITUDE`});
				bounds.extend(latLng);
				bound_length++;
			{+END}
		{+END}
		var bound_by_contents=(bound_length==0);
		for (var i=0;i<data.length;i++)
		{
			latLng=new google.maps.LatLng(data[i][1],data[i][2]);
			if (bound_by_contents)
			{
				bounds.extend(latLng);
				bound_length++;
			}

			marker_options={
				position: latLng,
				title: data[i][0]
			};

			{$,Reenable if you have put appropriate images in place
				var categoryIcon='{$BASE_URL;/}/themes/default/images_custom/map_icons/catalogue_category_'+data[i][3]+'.png';
				marker_options.icon=categoryIcon;
			}
			if (data[i][6]==1)
			{
				var starIcon='{$BASE_URL;/}/themes/default/images_custom/star_highlight.png';
				marker_options.icon=starIcon;
			}

			marker=new google.maps.Marker(marker_options);

			{+START,IF,{CLUSTER}}
				markers.push(marker);
			{+END}
			{+START,IF,{$NOT,{CLUSTER}}}
				marker.setMap(data_map);
			{+END}

			google.maps.event.addListener(marker,'click',(function (arg_marker,entry_title,entry_id,entry_content)
			{
				return function ()
				{
					{$,Dynamically load entry details only when their marker is clicked.}
					var content=entry_content.replace(/<colgroup>(.|\n)*<\/colgroup>/,'').replace(/&nbsp;/g,' ');
					if (content!='')
					{
						info_window.setContent('<div class="global_middle_faux float_surrounder">'+content+'<\/div>');
						info_window.open(data_map,arg_marker);
					}
				};
			})(marker,data[i][0],data[i][4],data[i][5])); {$,These are the args passed to the dynamic function above.}
		}

		{+START,IF,{CLUSTER}}
			var markerCluster=new MarkerClusterer(data_map,markers);
		{+END}

		{$,Autofit the map around the markers}
		{+START,IF,{CENTER}}
			if (bound_length==0) {$,We may have to center at given lat/long after all if there are no pins}
			{
				data_map.setCenter(specified_center);
			} else
			if (bound_length==1) {$,Center around the only pin}
			{
				data_map.setCenter(new google.maps.LatLng(data[0][1],data[0][2]));
			} else {$,Good - autofit lots of pins}
			{
				data_map.fitBounds(bounds);
			}
		{+END}

		{$,Sample code to grab clicked positions
			var lastPoint;
			google.maps.event.addListener(data_map,'mousemove',function(point) \{
				lastPoint=point.latLng;
			\});
			google.maps.event.addListener(data_map,'click',function() \{
				console.log(lastPoint.lat()+', '+lastPoint.lng());
			\});
		}
	}
//]]></script>

{+START,IF_NON_EMPTY,{TITLE}}
<section class="box box___block_main_google_map inline_block"><div class="box_inner">
	<h3>{TITLE*}</h3>
{+END}

	<div style="width:{WIDTH}; height:{HEIGHT}" id="{DIV_ID*}"></div>

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			google.load('maps','3',{callback: google_map_users_initialize,other_params:''{+START,IF_NON_EMPTY,{REGION}},region:'{REGION;/}'{+END}});
		});
	//]]></script>

{+START,IF_NON_EMPTY,{TITLE}}
</div></section>
{+END}

