(function ($cms) {
    'use strict';

    $cms.templates.formScreenInputMapPosition = function formScreenInputMapPosition(params, container) {
        var name = strVal(params.name),
            googleMapKey = strVal(params.googleMapKey),
            latitude = strVal(params.latitude),
            latitudeInput = container.querySelector('#' + name + '_latitude'),
            longitude = strVal(params.longitude),
            longitudeInput = container.querySelector('#' + name + '_longitude');

        $cms.requireJavascript('https://www.google.com/jsapi').then(function () {
            window.setTimeout(function() {
                window.google.load('maps', '3', { callback: google_map_users_initialize, other_params: ((googleMapKey !== '') ? 'key=' + googleMapKey : '') });
            },0);
        });

        $cms.dom.on(container, 'change', '.js-change-set-place-marker', function () {
            place_marker(latitudeInput.value, longitudeInput.value);
        });

        $cms.dom.on(container, 'click', '.js-click-geolocate-user-for-map-field', function () {
            geolocate_user_for_map_field();
        });

        var marker, map, last_point;

        function google_map_users_initialize() {
            marker = new google.maps.Marker();

            var bounds = new google.maps.LatLngBounds(),
                center = new google.maps.LatLng(((latitude !== '') ? latitude : 0), ((longitude !== '') ? longitude : 0));

            map = new google.maps.Map(document.getElementById('map_position_' + name), {
                zoom: (latitude !== '') ? 12 : 1,
                center: center,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                overviewMapControl: true,
                overviewMapControlOptions: { opened: true },
                styles: [{
                    featureType: 'poi',
                    elementType: 'labels',
                    stylers: [{ visibility: 'off' }]
                }]
            });

            var infoWindow = new google.maps.InfoWindow();

            //{$,Close InfoWindow when clicking anywhere on the map.}
            google.maps.event.addListener(map, 'click', function () {
                infoWindow.close();
            });

            // Show marker for current position
            if (latitude !== '') {
                place_marker(((latitude !== '') ? latitude : 0), ((longitude !== '') ? longitude : 0));
            }
            marker.setMap(map);

            //{$,Save into hidden fields}
            google.maps.event.addListener(map, 'mousemove', function (point) {
                last_point = point.latLng;
            });
            google.maps.event.addListener(map, 'click', _place_marker);
            google.maps.event.addListener(marker, 'click', _place_marker);
        }

        function _place_marker() {
            document.getElementById(name + '_latitude').value = last_point.lat();
            document.getElementById(name + '_longitude').value = last_point.lng();
            place_marker(last_point.lat(), last_point.lng());
            marker.setMap(map);
        }

        function place_marker(latitude, longitude) {
            var latLng = new google.maps.LatLng(latitude, longitude);
            marker.setPosition(latLng);
            map.setCenter(latLng);
            map.setZoom(12);
        }

        function geolocate_user_for_map_field() {
            if (navigator.geolocation != null) {
                try {
                    navigator.geolocation.getCurrentPosition(function (position) {
                        place_marker(position.coords.latitude, position.coords.longitude);

                        document.getElementById(name + '_latitude').value = position.coords.latitude;
                        document.getElementById(name + '_longitude').value = position.coords.longitude;
                    });
                } catch (ignore) {}
            }
        }
    };

    $cms.templates.blockMainGoogleMap = function blockMainGoogleMap(params) {
        var cluster = !!params.cluster,
            googleMapKey = strVal(params.googleMapKey),
            latitude = strVal(params.latitude),
            longitude = strVal(params.longitude),
            divId = strVal(params.divId),
            zoom = strVal(params.zoom),
            center = !!params.center,
            rawData = params.data,
            minLatitude = strVal(params.minLatitude),
            maxLatitude = strVal(params.maxLatitude),
            minLongitude = strVal(params.minLongitude),
            maxLongitude = strVal(params.maxLongitude),
            region = strVal(params.region);

        var scripts = ['https://www.google.com/jsapi'];

        if (cluster) {
            scripts.push('https://raw.githubusercontent.com/printercu/google-maps-utility-library-v3-read-only/master/markerclustererplus/src/markerclusterer_packed.js');
        }

        var options = {
            callback: google_map_initialize,
            other_params: (googleMapKey !== '') ? 'key=' + $cms.$CONFIG_OPTION.googleMapKey : ''
        };

        if (region !== '') {
            options.region = region;
        }

        if (typeof window.data_map === 'undefined') {
            window.data_map = null;
        }

        $cms.requireJavascript(scripts).then(function () {
            google.load('maps','3', options);
        });

        function google_map_initialize() {
            var bounds = new google.maps.LatLngBounds();
            var specified_center = new google.maps.LatLng((latitude !== '' ? latitude : 0.0), (longitude !== '' ? longitude : 0.0));
            var gOptions = {
                zoom: zoom,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                overviewMapControl: true,
                overviewMapControlOptions: { opened: true }
            };

            if (!center) { //{$,NB: the block center parameter means to autofit the contents cleanly; if the parameter is not set it will center about the given latitude/longitude}
                gOptions.center = specified_center;
            }

            window.data_map = new google.maps.Map(document.getElementById(divId), gOptions);


            var info_window=new google.maps.InfoWindow();

            //{$,Close InfoWindow when clicking anywhere on the map.}
            google.maps.event.addListener(data_map,'click',function () {
                info_window.close();
            });

            var data = [];
            if (Array.isArray(rawData) && rawData.length) {
                rawData.forEach(function (obj) {
                    data.push([
                        obj.entryTitle,
                        obj.latitude,
                        obj.longitude,
                        obj.ccId,
                        obj.entryContent,
                        obj.star
                    ]);
                });
            }

            //{$,Show markers}
            var latLng,marker_options,marker;
            var bound_length=0;
            if (cluster) {
                var markers=[];
            }

            if ((minLatitude !== maxLatitude) && (minLongitude !== maxLongitude)) {
                if ((minLatitude + minLongitude) !== '') {
                    latLng = new google.maps.LatLng(minLatitude, minLongitude);
                    bounds.extend(latLng);
                    bound_length++;
                }

                if ((maxLatitude + maxLongitude) !== '') {
                    latLng = new google.maps.LatLng(maxLatitude, maxLongitude);
                    bounds.extend(latLng);
                    bound_length++;
                }
            }

            var bound_by_contents=(bound_length==0);
            for (var i=0;i<data.length;i++) {
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

                /*{$,Reenable if you have put appropriate images in place
                 var categoryIcon='{$BASE_URL;/}/themes/default/images_custom/map_icons/catalogue_category_'+data[i][3]+'.png';
                 marker_options.icon=categoryIcon;}*/
                if (data[i][6]==1) {
                    var starIcon= $cms.$BASE_URL() + '/themes/default/images_custom/star_highlight.png';
                    marker_options.icon = starIcon;
                }

                marker=new google.maps.Marker(marker_options);

                if (cluster) {
                    markers.push(marker);
                } else {
                    marker.setMap(data_map);
                }

                google.maps.event.addListener(marker,'click',(function (arg_marker,entry_title,entry_id,entry_content) {
                    return function () {
                        //{$,Dynamically load entry details only when their marker is clicked.}
                        var content=entry_content.replace(/<colgroup>(.|\n)*<\/colgroup>/,'').replace(/&nbsp;/g,' ');
                        if (content!='') {
                            info_window.setContent('<div class="global_middle_faux float_surrounder">'+content+'<\/div>');
                            info_window.open(data_map,arg_marker);
                        }
                    };
                })(marker,data[i][0],data[i][4],data[i][5])); //{$,These are the args passed to the dynamic function above.}
            }

            if (cluster) {
                var markerCluster=new MarkerClusterer(data_map,markers);
            }

            //{$,Autofit the map around the markers}
            if (center) {
                if (bound_length == 0) {//{$,We may have to center at given lat/long after all if there are no pins}
                    data_map.setCenter(specified_center);
                } else if (bound_length == 1) {//{$,Center around the only pin}
                    data_map.setCenter(new google.maps.LatLng(data[0][1], data[0][2]));
                } else {//{$,Good - autofit lots of pins}
                    data_map.fitBounds(bounds);
                }
            }
            //{$,Sample code to grab clicked positions
            var lastPoint;
            google.maps.event.addListener(data_map,'mousemove',function(point) {
                lastPoint=point.latLng;
            });
            google.maps.event.addListener(data_map,'click',function() {
                console.log(lastPoint.lat()+', '+lastPoint.lng());
            });
        }
    }
}(window.$cms));