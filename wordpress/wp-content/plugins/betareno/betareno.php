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

		// Web service handlers
		add_action( 'wp_ajax_betareno-add-idea', array( __CLASS__, 'action_wp_ajax_betareno_add_idea' ) );
		add_action( 'wp_ajax_nopriv_betareno-add-idea', array( __CLASS__, 'action_wp_ajax_betareno_add_idea' ) );
	}

	static public function register_types() {
		register_post_type( 'idea', array(
			'description' => 'An idea for an activity at a location',
			'public' => true,
			'show_ui' => true,
			'show_in_menu' => true,
			'menu_postition' => null,
			'menu_icon' => null,
			'capability_type' => 'post',
			'taxonomies' => array( 'actor', 'post_category' ),
			'lables' => array(
				'name' => 'Ideas',
				'singular_name' => 'Idea'
			),
			'show_in_nav_menus' => true
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

		$postdata = array(
			'post_type' => 'idea',
			'post_title' => $_POST['what']
		);

		$post_id = wp_insert_post( $postdata, true );
		if ( is_wp_error( $post_id ) ) {
			$response['code'] = 500;
			$response['message'] = $post_id->get_error_message();
			echo json_encode( $response );
			exit();
		}

		$response['idea'] = array(
			'ID' => $post_id,
			'what' => $_POST['what'],
			'who' => $_POST['who'],
			'latitude' => $_POST['latitude'],
			'longitude' => $_POST['longitude'],
			'votes' => -3,
			'before_photo_url' => '',
			'after_photo_url' => ''
		);
		echo json_encode( $response );
		exit();
	}

	static public function verify_api_key( $key ) {
		return ('BetaReno4hack4reno' == $key );
	}

}