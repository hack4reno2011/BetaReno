(function( $ ) {
	var $add_start_button, $add_panel, geocoder, add_marker;

	GeoMashup.addAction( 'objectMarkerOptions', function( properties, options, object ) {
		if ( object.status ) {

			options.iconShadow = '';

			if ( 'proposal' === object.status ) {

				options.icon = properties.template_url_path + '/images/proposal-gray.png';
				options.iconSize = [ 18, 31 ];
				options.iconAnchor = [ 9, 27 ];

			} else if ( 'plan' === object.status ) {

				options.icon = properties.template_url_path + '/images/plan-gray.png';
				options.iconSize = [ 40, 31 ];
				options.iconAnchor = [ 20, 15 ];

			} else if ( 'feature' === object.status ) {

				options.icon = properties.template_url_path + '/images/feature-gray.png';
				options.iconSize = [ 37, 38 ];
				options.iconAnchor = [ 16, 38 ];

			} else {

				options.icon = properties.template_url_path + '/images/flop-gray.png';
				options.iconSize = [ 32, 44 ];
				options.iconAnchor = [ 16, 38 ];

			}
		}
	} );

	GeoMashup.addAction( 'newMap', function( properties, mxnmap ) {
		var googlemap = mxnmap.getMap(),
			bubble_parts = ['<p><label for="where_input">Location<label>',
				'<input id="where_input" type="text" size="40" /></p>',
				'<p><label for="what_input">What should be done here?</label>',
				'<textarea id="what_input" rows="3" cols="40"></textarea></p>',
				'<p><label for="who_select">Who will do it?</label>',
				'<select id="who_select"><option>city government</option>',
				'<option>myself</option>',
				'<option>community group</option>',
				'<option>volunteers</option>',
				'<option>property owner</option>',
				'</select><input id="submit_button" type="button" value="Add" /></p>' ],
			geocoder = new google.maps.Geocoder(),
			$where_input, $what_input, $who_select, $submit_button, autocomplete;

		$add_start_button = parent.jQuery( '#add_start_button' ).click( function() {
			var mxn_center = mxnmap.getCenter();
			$add_start_button.hide();
			add_marker = new mxn.Marker( mxn_center );
			add_marker.addData( {
				icon: properties.template_url_path + '/images/proposal-yellow.png',
				iconSize: [ 18, 31 ],
				iconAnchor: [ 9, 27 ],
				infoBubble: bubble_parts.join('')
			} );
			mxnmap.addMarker( add_marker );
			add_marker.closeInfoBubble.addHandler( function() {
				mxnmap.removeMarker( add_marker );
				$add_start_button.show();
			} );
			add_marker.openBubble();
			// openBubble has no working callback - go proprietary
			google.maps.event.addListener( add_marker.proprietary_infowindow, 'domready', function() {
				$where_input = $( '#where_input' );
				$what_input = $( '#what_input' );
				$who_select = $( '#who_select' );
				$submit_button = $( '#submit_button' ).click( function() {
					$.ajax( {
						url: properties.ajaxurl + '?action=betareno-add-idea',
						dataType: 'json',
						type: 'POST',
						data: {
							'api_key': 'BetaReno4hack4reno',
							'what': $what_input.val(),
							'who': $who_select.val(),
							'latitude': add_marker.location.lat,
							'longitude': add_marker.location.lon
						},
						success: function( data, status ) {
							// Out of time!
							parent.location.reload();
						}
					})
				});
				autocomplete = new google.maps.places.Autocomplete( $where_input.get(0), { bounds: googlemap.getBounds() } );
				autocomplete.bindTo( 'bounds', googlemap );
				google.maps.event.addListener( autocomplete, 'place_changed', function() {
					var new_location = autocomplete.getPlace().geometry.location;
					add_marker.proprietary_marker.setPosition( new_location );
					add_marker.update();
					mxnmap.setCenter( add_marker.location );
					geocoder.geocode( { location: add_marker.proprietary_marker.getPosition() }, function( results, status ) {
						if ( status == google.maps.GeocoderStatus.OK ) {
							$where_input.val( results[0].formatted_address );
						}
					} );
				} );

				geocoder.geocode( { location: add_marker.proprietary_marker.getPosition() }, function( results, status ) {
					if ( status == google.maps.GeocoderStatus.OK ) {
						$where_input.val( results[0].formatted_address ).select();
					}
				} );
			} );
		} );
	} );

	GeoMashup.addAction( 'loadedMap', function( properties, map ) {
		var google_map = map.getMap();
		var custom_styles = [ {stylers: [ {lightness: 25}, {saturation: -35} ]} ];
		var map_type = new google.maps.StyledMapType( custom_styles, {name: 'betareno'} );

		google_map.mapTypes.set( 'betareno', map_type );
		google_map.setMapTypeId( 'betareno' );



	} );

})( jQuery );