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

GeoMashup.addAction( 'loadedMap', function( properties, map ) {
	var google_map = map.getMap();
	var custom_styles = [ { stylers: [ { lightness: 25 }, { saturation: -35 } ] } ];
	var map_type = new google.maps.StyledMapType( custom_styles, { name: 'betareno' } );
	google_map.mapTypes.set( 'betareno', map_type );
	google_map.setMapTypeId( 'betareno' );
} );

