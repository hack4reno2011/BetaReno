<?php
/*
Plugin Name: Beta Reno
Plugin URI: https://github.com/hack4reno/BetaReno
Description: Idea map for the city of Reno, built at http://hack4reno.com
Version: 0.1
Author: Dylan Kuhn
Author URI: http://www.cyberhobo.net/
Minimum WordPress Version Required: 3.0
License: GPL2+
*/

/*  Copyright 2011  Dylan Kuhn  (email : cyberhobo@cyberhobo.net)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License, version 2 or later, as
    published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

add_action( 'init', array( 'BetaReno', 'action_init' ) );

class BetaReno {

	static public function action_init() {

		self::register_types();

		// Use Reno's time zone
		date_default_timezone_set( 'America/Los_Angeles' );

		// Web service handlers
		add_action( 'wp_ajax_betareno-add-idea', array( __CLASS__, 'action_wp_ajax_betareno_add_idea' ) );
		add_action( 'wp_ajax_nopriv_betareno-add-idea', array( __CLASS__, 'action_wp_ajax_betareno_add_idea' ) );
		add_action( 'wp_ajax_betareno-get-ideas', array( __CLASS__, 'action_wp_ajax_betareno_get_ideas' ) );
		add_action( 'wp_ajax_nopriv_betareno-get-ideas', array( __CLASS__, 'action_wp_ajax_betareno_get_ideas' ) );
	}

	static public function register_types() {
		$idea_type = register_post_type( 'idea', array(
			'description' => 'An idea for an activity at a location',
			'public' => true,
			'show_ui' => true,
			'show_in_menu' => true,
			'menu_postition' => null,
			'menu_icon' => null,
			'capability_type' => 'post',
			'taxonomies' => array( 'actor', 'post_category' ),
			'labels' => array(
				'name' => 'Ideas',
				'singular_name' => 'Idea',
				'add_new' => 'Add New',
				'add_new_item' => 'Add New Idea',
				'edit_item' => 'Edit Post',
				'new_item' => 'New Idea',
				'view_item' => 'View Idea',
				'search_items' => 'Search Ideas',
				'not_found' => 'No ideas found.',
				'not_found_in_trash' => 'No ideas found in Trash.',
				'all_items' => 'All Ideas'
			),
			'show_in_nav_menus' => true,
			'supports' => array( 'title', 'thumbnail', 'custom-fields' )
		) );

		register_taxonomy( 'actor', 'idea', array(
			'labels' => array(
				'name' => 'Actors',
				'singular_name' => 'Actor',
				'search_items' => 'Search Actors',
				'popular_items' => 'Popular Actors',
				'all_items' => 'All Actors',
				'edit_item' => 'Edit Actor',
				'view_item' => 'View Actor',
				'add_new_item' => 'Add New Actor',
				'new_item_name' => 'New Actor Name',
				'separate_items_with_commas' => 'Separate actors with commas',
				'add_or_remove_items' => 'Add or remove actors',
				'choose_from_most_used' => 'Chose from the most used actors'
			)
		) );
	}

	static public function action_wp_ajax_betareno_get_ideas() {

		// default is within 5 miles of downtown Reno
		$default_args = array(
			'lat' => '39.524435',
			'lng' => '-119.811745',
			'r' => '5'
		);
		$args = wp_parse_args( $_GET, $default_args );
		extract( $args );

		$response = array( 'code' => 200, 'message' => 'ok' );

		$geo_query = array(
			'object_name' => 'post',
			'map_post_type' => 'idea',
			'near_lat' => $lat,
			'near_lng' => $lng,
			'radius_mi' => $r
		);
		$idea_locations = GeoMashupDB::get_object_locations( $geo_query );
		$response['ideas'] = array();
		foreach( $idea_locations as $idea_location ) {
			$idea = array(
				'ID' => $idea_location->object_id,
				'what' => $idea_location->label,
				'latitude' => $idea_location->lat,
				'longitude' => $idea_location->lng
			);

			// Who
			$actor_terms = wp_get_object_terms( $idea_location->object_id, 'actor' );
			if ( is_wp_error( $actor_terms ) ) {
				$idea['who'] = '';
			} else {
				$idea['who'] = $actor_terms[0]->name;
			}

			$idea['when'] = get_post_meta( $idea_location->object_id, 'when', true );

			$idea['votes'] = 1;

			// Photos
			$idea['before_photo_url'] = '';
			$before_photo_attachments = get_posts( array(
				'post_type' => 'attachment',
				'post_mime_type' => 'image',
				'post_parent' => $idea_location->object_id,
				'meta_key' => 'photo_type',
				'meta_value' => 'before'
			) );
			if ( !empty( $before_photo_attachments ) ) {
				list( $idea['before_photo_url'], $width, $height ) = wp_get_attachment_image_src( $before_photo_attachments[0]->ID );
			}

			$idea['after_photo_url'] = '';
			$after_photo_attachments = get_posts( array(
				'post_type' => 'attachment',
				'post_mime_type' => 'image',
				'post_parent' => $idea_location->object_id,
				'meta_key' => 'photo_type',
				'meta_value' => 'after'
			) );
			if ( !empty( $after_photo_attachments ) )  {
				list( $idea['after_photo_url'], $width, $height ) = wp_get_attachment_image_src( $after_photo_attachments[0]->ID );
			}

			$response['ideas'][] = $idea;
		}

		echo json_encode( $response );
		exit();
	}

	static public function action_wp_ajax_betareno_add_idea() {

		$response = array( 'code' => 200, 'message' => 'ok' );

		$required_fields = array( 'api_key', 'what', 'who', 'longitude', 'latitude' );
		foreach ( $required_fields as $field ) {
			if ( empty( $_POST[$field] ) ) {
				$response['code'] = 400;
				$response['message'] = 'Missing required field "' . $field . '"';
				echo json_encode( $response );
				exit();
			}
		}

		if ( !self::verify_api_key( $_POST['api_key' ] ) ) {
			$response['code'] = 403;
			$response['message'] = 'Invalid API key.' . $field . '"';
			echo json_encode( $response );
			exit();
		}

		// Create the post
		$postdata = array(
			'post_type' => 'idea',
			'post_title' => $_POST['what'],
			'post_status' => 'publish'
		);
		$post_id = wp_insert_post( $postdata, true );
		if ( is_wp_error( $post_id ) ) {
			$response['code'] = 500;
			$response['message'] = $post_id->get_error_message();
			echo json_encode( $response );
			exit();
		}
		$post = get_post( $post_id );

		// Set the actor
		$term_ids = wp_set_object_terms( $post_id, $_POST['who'], 'actor' );
		if ( is_wp_error( $term_ids ) ) {
			$response['code'] = 500;
			$response['message'] = $term_ids->get_error_message();
			echo json_encode( $response );
			exit();
		}
		$actor = get_term( $term_ids[0], 'actor' );

		// Set the location
		$location_id = GeoMashupDB::set_object_location( 'post', $post_id, array(
			'lat' => $_POST['latitude'],
			'lng' => $_POST['longitude']
		) );
		if ( is_wp_error( $location_id ) ) {
			$response['code'] = 500;
			$response['message'] = $location_id->get_error_message();
			echo json_encode( $response );
			exit();
		}
		$location = GeoMashupDB::get_location( $location_id );

		// Set the when
		$when = '';
		if ( isset( $_POST['when'] ) ) {
			$time = strtotime( $_POST['when'] );
			if ( $time ) {
				$when = date( 'Y-m-d h:i:00 e', $time );
				update_post_meta( $post_id, 'when', $when );
			}
		}

		// Handle photos
		$before_photo_url = '';
		if ( isset( $_FILES['before_photo'] ) ) {
			$before_photo_id = media_handle_upload( 'before_photo',  $post_id, array( 'post_title' => 'Before' ) );
			if ( !is_wp_error( $before_photo_id ) ) {
				update_post_meta( $before_photo_id, 'photo_type', 'before' );
				list( $before_photo_url, $width, $height ) = wp_get_attachment_image_src( $before_photo_id );
			}
		}
		$after_photo_url = '';
		if ( isset( $_FILES['after_photo'] ) ) {
			$after_photo_id = media_handle_upload( 'after_photo',  $post_id, array( 'post_title' => 'After' ) );
			if ( !is_wp_error( $after_photo_id ) ) {
				update_post_meta( $after_photo_id, 'photo_type', 'after' );
				list( $after_photo_url, $width, $height ) = wp_get_attachment_image_src( $after_photo_id );
			}
		}

		// Respond with the new idea
		$response['idea'] = array(
			'ID' => $post_id,
			'what' => $post->post_title,
			'who' => $actor->name,
			'when' => $when,
			'latitude' => $location->lat,
			'longitude' => $location->lng,
			'votes' => 1,
			'before_photo_url' => $before_photo_url,
			'after_photo_url' => $after_photo_url
		);
		echo json_encode( $response );
		exit();
	}

	static public function verify_api_key( $key ) {
		return ('BetaReno4hack4reno' == $key );
	}

}