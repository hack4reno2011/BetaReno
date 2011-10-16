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

function childtheme_override_single_post() { ?>

	<?php $actors = wp_get_object_terms( get_the_ID(), 'actor' ); ?>

		<h1><a href="<?php the_permalink() ?>" title="<?php the_title_attribute(); ?>"><?php the_title(); ?></a></h1>
		<p><strong>Who:</strong> <?php echo empty( $actors ) ? '' : $actors[0]->name; ?></p>
	<?php $when = get_post_meta( get_the_ID(), 'when', true ); ?>
	<?php if ( $when ) : ?>
		<p><strong>When:</strong> <?php echo $when; ?></p>
	<?php endif; ?>

	<?php
		$before_photo_attachments = get_posts( array(
			'post_type' => 'attachment',
			'post_mime_type' => 'image',
			'post_parent' => get_the_ID(),
			'meta_key' => 'photo_type',
			'meta_value' => 'before'
		) );
		if ( !empty( $before_photo_attachments ) ) { ?>
		<p><strong>Before Photo:</strong>
			<?php echo wp_get_attachment_image( $before_photo_attachments[0]->ID, 'large' ); ?>
		</p>
	<?php } ?>

<?php }
