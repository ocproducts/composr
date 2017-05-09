(function ($cms) {
    'use strict';

    $cms.templates.blockMainGoogleMapUsers = function blockMainGoogleMapUsers(params) {
        var cluster = !!params.cluster,
            latitude = strVal(params.latitude),
            longitude = strVal(params.longitude),
            zoom = strVal(params.zoom),
            region = strVal(params.region),
            dataEval = strVal(params.data),
            geolocateUser = !!params.geolocateUser,
            setCoordUrl = strVal(params.setCoordUrl),
            username = strVal(params.username),
            usernamePrefix = strVal(params.usernamePrefix),
            googleMapKey = strVal(params.googleMapKey);

        var scripts = ['https://www.google.com/jsapi'];

        if (cluster) {
            scripts.push('https://raw.githubusercontent.com/printercu/google-maps-utility-library-v3-read-only/master/markerclustererplus/src/markerclusterer_packed.js');
        }

        var options = {
            callback: googleMapUsersInitialize,
            other_params: (googleMapKey !== '') ? 'key=' + $cms.$CONFIG_OPTION('googleMapKey') : ''
        };

        if (region !== '') {
            options.region = region;
        }
        $cms.requireJavascript(scripts).then(function () {
            google.load('maps','3', options);
        });

        function googleMapUsersInitialize() {
            var bounds = new google.maps.LatLngBounds();
            var center = new google.maps.LatLng((latitude !== '' ? latitude : 0.0), (longitude !== '' ? longitude : 0.0));
            var map = new google.maps.Map(document.getElementById('map_canvas'), {
                zoom: zoom,
                center: center,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                overviewMapControl: true,
                overviewMapControlOptions: {
                    opened: true
                }
            });

            if (latitude === '') {
                if (google.loader.ClientLocation) {
                    map.setCenter(new google.maps.LatLng(google.loader.ClientLocation.latitude, google.loader.ClientLocation.longitude), 15);
                } else {
                    if (typeof navigator.geolocation !== 'undefined') {
                        try {
                            navigator.geolocation.getCurrentPosition(function(position) {
                                map.setCenter(new google.maps.LatLng(position.coords.latitude,position.coords.longitude));
                            });
                        } catch (e) {}
                    }
                }
            }

            var info_window = new google.maps.InfoWindow();

            // Close InfoWindow when clicking anywhere on the map.
            google.maps.event.addListener(map, 'click', function () {
                info_window.close();
            });

            if (dataEval !== '') {
                eval.call(window, dataEval);
            }

            //{$,Show markers}
            var markers = [];
            for (var i = 0; i < data.length; i++) {
                addDataPoint(data[i], bounds, markers, info_window, map);
            }

            if (cluster) {
                var markerCluster = new MarkerClusterer(map,markers);
            }
            //{$,Fit the map around the markers, but only if we want the map centered.}
            if (params.center) {
                map.fitBounds(bounds);
            }


            if (geolocateUser && (setCoordUrl !== '')) {
                // Geolocation for current member to get stored onto the map
                if (typeof navigator.geolocation !== 'undefined') {
                    try {
                        navigator.geolocation.getCurrentPosition(function(position) {
                            $cms.doAjaxRequest(setCoordUrl + position.coords.latitude + '_' + position.coords.longitude + $cms.keepStub(), function() {});
                            var initial_location = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
                            map.setCenter(initial_location);
                            addDataPoint([username, position.coords.latitude, position.coords.longitude, ''], bounds, markers, info_window, map);
                        });
                    } catch (e) {}
                }
            }

            /*Sample code to grab clicked positions
             var last_point;
             google.maps.event.addListener(map,'mousemove',function(point) \{
             last_point=point.latLng;
             \});
             google.maps.event.addListener(map,'click',function() \{
             console.log(last_point.lat()+', '+last_point.lng());
             \});
             }*/
        }

        function addDataPoint(data_point,bounds,markers,info_window,map) {
            var lat_lng = new google.maps.LatLng(data_point[1], data_point[2]);
            bounds.extend(lat_lng);

            var marker_options = {
                position: lat_lng,
                title: usernamePrefix + data_point[0]
            };

            /*{$,Reenable if you have put appropriate images in place
             var usergroup_icon=new GIcon(G_DEFAULT_ICON);
             usergroup_icon.image='{$BASE_URL;/}/themes/default/images_custom/map_icons/usergroup_'+data_point[3]+'.png';
             marker_options.icon=usergroup_icon;
             }*/

            var marker = new google.maps.Marker(marker_options);

            if (cluster) {
                markers.push(marker);
            } else {
                marker.setMap(map);
            }

            google.maps.event.addListener(marker, 'click', (function (arg_marker, arg_member) {
                return function () {
                    //{$,Dynamically load a specific members details only when their marker is clicked.}
                    $cms.doAjaxRequest($cms.$BASE_URL() + '/data_custom/get_member_tooltip.php?member=' + arg_member + $cms.keepStub(), function (reply) {
                        var content = reply.querySelector('result').firstChild.nodeValue;
                        if (content != '') {
                            info_window.setContent('<div class="global_middle_faux float_surrounder">' + content + '<\/div>');
                            info_window.open(map, arg_marker);
                        }
                    });
                };
            })(marker, data_point[0])); //{$,These are the args passed to the dynamic function above.}
        }
    };

}(window.$cms));