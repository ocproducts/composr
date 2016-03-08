<script src="https://www.google.com/jsapi"></script>
<script>// <![CDATA[
	var marker,map,last_point;
	function google_map_users_initialize()
	{
		marker=new google.maps.Marker();
		var bounds=new google.maps.LatLngBounds();
		var center=new google.maps.LatLng({$?,{$IS_EMPTY,{LATITUDE}},0,{LATITUDE;}},{$?,{$IS_EMPTY,{LONGITUDE`}},0,{LONGITUDE`}});
		map=new google.maps.Map(document.getElementById('map_position_{NAME;/}'),
		{
			zoom: {$?,{$IS_NON_EMPTY,{LATITUDE}},12,1},
			center: center,
			mapTypeId: google.maps.MapTypeId.ROADMAP,
			overviewMapControl: true,
			overviewMapControlOptions:
			{
				opened: true
			},
			styles: [{
				featureType: 'poi',
				elementType: 'labels',
				stylers: [ { visibility: 'off' } ]
			}]
		});

		var infoWindow=new google.maps.InfoWindow();

		{$,Close InfoWindow when clicking anywhere on the map.}
		google.maps.event.addListener(map, 'click', function ()
		{
			infoWindow.close();
		});

		{$,Show marker for current position}
		{+START,IF_NON_EMPTY,{LATITUDE}}
			place_marker({$?,{$IS_EMPTY,{LATITUDE`}},0,{LATITUDE`}},{$?,{$IS_EMPTY,{LONGITUDE`}},0,{LONGITUDE`}});
		{+END}
		marker.setMap(map);

		{$,Save into hidden fields}
		google.maps.event.addListener(map, 'mousemove', function(point) {
			last_point=point.latLng;
		});
		google.maps.event.addListener(map, 'click', _place_marker);
		google.maps.event.addListener(marker, 'click', _place_marker);
	}

	function _place_marker()
	{
		document.getElementById('{NAME;/}_latitude').value=last_point.lat();
		document.getElementById('{NAME;/}_longitude').value=last_point.lng();
		place_marker(last_point.lat(),last_point.lng());
		marker.setMap(map);
	}

	function place_marker(latitude,longitude)
	{
		var latLng=new google.maps.LatLng(latitude,longitude);
		marker.setPosition(latLng);
		map.setCenter(latLng);
		map.setZoom(12);
	}

	function geolocate_user_for_map_field()
	{
		if (typeof navigator.geolocation!='undefined')
		{
			try
			{
				navigator.geolocation.getCurrentPosition(function(position) {
					place_marker(position.coords.latitude,position.coords.longitude)

					document.getElementById('{NAME;/}_latitude').value=position.coords.latitude;
					document.getElementById('{NAME;/}_longitude').value=position.coords.longitude;
				});
			}
			catch (e) {}
		}
	}
//]]></script>

<div id="map_position_{NAME*}" style="width:100%; height:300px"></div>

<label for="{NAME*}_latitude">
	{!LATITUDE}
	<input onchange="place_marker(this.form.elements['latitude'].value,this.form.elements['longitude'].value);" type="number" step="any"{+START,IF,{REQUIRED}} class="hidden_required"{+END} id="{NAME*}_latitude" name="latitude" value="{LATITUDE*}" />
</label>

<label for="{NAME*}_longitude">
	{!LONGITUDE}
	<input onchange="place_marker(this.form.elements['latitude'].value,this.form.elements['longitude'].value);" type="number" step="any"{+START,IF,{REQUIRED}} class="hidden_required"{+END} id="{NAME*}_longitude" name="longitude" value="{LONGITUDE*}" />
</label>

<input class="button_micro buttons__search" type="button" value="{!FIND_ME}" onclick="geolocate_user_for_map_field(); return false;" />

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		google.load('maps','3', {callback: google_map_users_initialize, other_params:''});
	});
//]]></script>
