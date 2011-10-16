<?php /*
Plugin Name: Geo Mashup Custom
Plugin URI: http://code.google.com/p/wordpress-geo-mashup/downloads
Description: Customization for BetaReno. When this plugin is active, Geo Mashup will use these files and you can <a href="?geo_mashup_custom_list=1">list current custom files</a> here. Subfolders are okay for your own use, but won't be listed.
Version: 1.0+
Author: Dylan Kuhn
Author URI: http://www.cyberhobo.net/
Minimum WordPress Version Required: 2.6
*/

/*
Copyright (c) 2005-2009 Dylan Kuhn

This program is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE. See the GNU General Public License for more
details.
*/

/**
 * The Geo Mashup Custom class.
 */
if ( !class_exists( 'GeoMashupCustom' ) ) {
class GeoMashupCustom {
	var $files = array();
	var $found_files;
	var $dir_path;
	var $url_path;
	var $basename;
	var $warnings = '';

	/**
	 * PHP4 Constructor
	 */
	function GeoMashupCustom() {

		// Initialize members
		$this->dir_path = dirname( __FILE__ );
		$this->basename = plugin_basename( __FILE__ );
		$dir_name = substr( $this->basename, 0, strpos( $this->basename, '/' ) );
		$this->url_path = trailingslashit( WP_PLUGIN_URL ) . $dir_name;
		load_plugin_textdomain( 'GeoMashupCustom', 'wp-content/plugins/'.$dir_name, $dir_name );
		
		// Inventory custom files
		if ( $dir_handle = @ opendir( $this->dir_path ) ) {
			$self_file = basename( __FILE__ );
			while ( ( $custom_file = readdir( $dir_handle ) ) !== false ) {
				if ( $self_file != $custom_file && !strpos( $custom_file, '-sample' ) && !is_dir( $custom_file ) ) {
					$this->files[$custom_file] = trailingslashit( $this->url_path ) . $custom_file;
				}
			}
		}

		// Scan Geo Mashup after it has been loaded
		add_action( 'plugins_loaded', array( $this, 'plugins_loaded' ) );

		// Output messages
		add_action( 'after_plugin_row_' . $this->basename, array( $this, 'after_plugin_row' ), 10, 2 );

		add_action( 'init', array( $this, 'action_init' ) );
	}

	function action_init() {
		add_filter( 'geo_mashup_locations_json_object', array( $this, 'filter_geo_mashup_locations_json_object' ), 10, 2 );
	}

	// Add BetaReno data to map objects
	function filter_geo_mashup_locations_json_object( $properties, $object ) {
		if ( 'post' == $properties['object_name'] ) {
			$properties['status'] = 'proposal';
			$properties['when'] = get_post_meta( $object->object_id, 'when', true );
			if ( $properties['when'] ) {
				$when_time = strtotime( $properties['when'] );
				if ( $when_time ) {
					if ( $when_time < time() ) {
						// Need voting data to determine feature/flop
						$properties['status'] = 'feature';
					} else {
						$properties['status'] = 'plan';
					}
				}
			}
		}
		return $properties;
	}

	/**
	 * Once all plugins are loaded, we can examine Geo Mashup.
	 */
	function plugins_loaded() {
		if ( defined( 'GEO_MASHUP_DIR_PATH' ) ) {
			// Check version
			if ( GEO_MASHUP_VERSION <= '1.2.4' ) {
				$this->warnings .= __( 'Custom files can be stored safely in this plugin folder, but will only be used by versions of Geo Mashup later than 1.2.4.', 'GeoMashupCustom' ) .
					'<br/>';
			}
			$this->found_files = get_option( 'geo_mashup_custom_found_files' );
			if ( empty( $this->found_files ) ) {
				$this->found_files = $this->rescue_files();
				update_option( 'geo_mashup_custom_found_files', $this->found_files );
			}
		}
	}

	/**
	 * Rescue known custom files from the Geo Mashup folder.
	 */
	function rescue_files() {
		$results = array( 'ok' => array(), 'failed' => array() );
		$check_files = array( 'custom.js', 'map-style.css', 'info-window.php', 'full-post.php', 'user.php', 'comment.php' );
		foreach( $check_files as $file ) {
			if ( !isset( $this->files[$file] ) ) {
				$endangered_file = trailingslashit( GEO_MASHUP_DIR_PATH ) . $file;
				if ( is_readable( $endangered_file ) ) {
					$safe_file = trailingslashit( $this->dir_path ) . $file; 
					if ( copy( $endangered_file, $safe_file ) ) {
						$this->file[$file] = trailingslashit( $this->url_path ) . $file;
						array_push( $results['ok'], $file );
					} else {
						array_push( $results['failed'], $file );
					}
				}
			}
		}
		return $results;
	}

	/**
	 * Display any messages after the plugin row.
	 * 
	 * @param object $plugin_data Plugin data.
	 * @param string $context 'active', 'inactive', etc.
	 */
	function after_plugin_row( $plugin_data = null, $context = '' ) {
		if ( !empty( $_GET['geo_mashup_custom_list'] ) ) {
			echo '<tr><td colspan="5">' . __( 'Current custom files: ', 'GeoMashupCustom') .
				implode( ', ', array_keys( $this->files ) ) . '</td></tr>';
		}
		if ( !empty( $this->warnings ) ) {
			echo '<tr><td colspan="5">' . $this->warnings . '</td></tr>';
		}
	}

	/**
	 * Get the URL of a custom file if it exists.
	 *
	 * @param string $file The custom file to check for.
	 * @return URL or false if the file is not found.
	 */
	function file_url( $file ) {
		$url = false;
		if ( isset( $this->files[$file] ) ) {
			$url = $this->files[$file];
		}
		return $url;
	}

} // end Geo Mashup Custom class

// Instantiate
$geo_mashup_custom = new GeoMashupCustom();

} // end if Geo Mashup Custom class exists
