<script {$CSP_NONCE_HTML} src="https://maps.googleapis.com/maps/api/js{+START,IF_NON_EMPTY,{API_KEY}}?key={API_KEY*}{+END}"></script>

<script {$CSP_NONCE_HTML}>
	function initialize_{ID%}() {
		var map = new google.maps.Map(document.getElementById('map_{ID%}'), {
			zoom: 2,
			center: {
				// A good center of the world to default with
				lat: 25.00,
				lng: 45.0,
			},
		});

		function addMarker(map, loc, color, intensity, label, description) {
			var marker;

			if (intensity !== null) {
				var _intensity = '' + intensity;

				var scale;
				if (_intensity.length >= 6) {
					scale = 26;
				} else if (_intensity.length == 5) {
					scale = 23;
				} else if (_intensity.length == 4) {
					scale = 19;
				} else if (_intensity.length == 3) {
					scale = 15;
				} else if (_intensity.length == 2) {
					scale = 12;
				} else {
					scale = 8;
				}

				marker = new google.maps.Marker({
					map: map,

					position: loc,

					title: label,

					icon: {
						path: google.maps.SymbolPath.CIRCLE,
						fillOpacity: 1,
						fillColor: color,
						strokeOpacity: 1,
						strokeWeight: 1,
						strokeColor: '#333333',
						scale: scale,
					},
					label: {
						color: '#000000',
						fontSize: '12px',
						fontWeight: '600',
						text: _intensity,
					}
				});
			} else {
				marker = new google.maps.Marker({
					map: map,

					position: loc,

					label: {
						fontSize: '12px',
						fontWeight: '600',
						text: label,
					}
				});
			}

			var infowindow = new google.maps.InfoWindow({
				content: description,
			});
			google.maps.event.addListener(marker, 'click', function () {
				infowindow.open(map, marker);
			});
		}

		{+START,LOOP,DATA}
			addMarker(map, { lat: {LATITUDE*}, lng: {LONGITUDE*} }, '{COLOR;*/}', {$?,{$IS_EMPTY,{INTENSITY}},null,{INTENSITY%}}, '{LABEL;*/}', '{DESCRIPTION;*/}');
		{+END}
	}

	google.maps.event.addDomListener(window, 'load', initialize_{ID%});
</script>

<div id="map_{ID%}" style="width: {WIDTH*}; height: {HEIGHT*};"></div>
