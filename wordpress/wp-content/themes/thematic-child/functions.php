<?php

//
//  Custom Child Theme Functions
//

// Unleash the power of Thematic's dynamic classes
// 
// define('THEMATIC_COMPATIBLE_BODY_CLASS', true);
// define('THEMATIC_COMPATIBLE_POST_CLASS', true);

// Unleash the power of Thematic's comment form
//
// define('THEMATIC_COMPATIBLE_COMMENT_FORM', true);

// Unleash the power of Thematic's feed link functions
//
// define('THEMATIC_COMPATIBLE_FEEDLINKS', true);

function childtheme_override_postheader_posttitle() {
	// No titles
	return '';
}

function childtheme_override_blogtitle() {
	// Logo image
	echo '<div id="blog-title"><img src="' . path_join( get_stylesheet_directory_uri(), 'images/betareno-logo-180.png' ) . '" alt="BetaReno" /></div>';
}
add_action('thematic_header','thematic_blogtitle',3);

function childtheme_override_blogdescription() {
	// No description
}

function childtheme_override_access() {
	// No nav menu
}
?>