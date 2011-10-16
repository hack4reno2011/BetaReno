<?php
// Info window template
?>
<div class="locationinfo post-location-info">
<?php if (have_posts()) : ?>

	<?php while (have_posts()) : the_post(); ?>
	<?php $actors = wp_get_object_terms( get_the_ID(), 'actor' ); ?>

		<p><strong>What:</strong> <a href="<?php the_permalink() ?>" title="<?php the_title_attribute(); ?>"><?php the_title(); ?></a></p>
		<p><strong>Who:</strong> <?php echo empty( $actors ) ? '' : $actors[0]->name; ?></p>
	<?php $when = get_post_meta( get_the_ID(), 'when', true ); ?>
	<?php if ( $when ) : ?>
		<p><strong>When:</strong> <?php echo $when; ?></p>
	<?php endif; ?>

<?php
	$before_photo_attachments = get_posts( array(
		'post_type' => 'attachment',
		'post_mime_type' => 'image',
		'post_parent' => $idea_location->object_id,
		'meta_key' => 'photo_type',
		'meta_value' => 'before'
	) );
	if ( !empty( $before_photo_attachments ) ) {
		echo wp_get_attachment_image( $before_photo_attachments[0]->ID );
	}
?>
	<?php endwhile; ?>

<?php else : ?>

	<h2 class="center">Not Found</h2>
	<p class="center">Sorry, but you are looking for something that isn't here.</p>

<?php endif; ?>

</div>
