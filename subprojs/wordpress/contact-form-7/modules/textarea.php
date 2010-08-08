<?php
/**
** A base module for [textarea] and [textarea*]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'textarea', 'wpef7_textarea_shortcode_handler', true );
wpef7_add_shortcode( 'textarea*', 'wpef7_textarea_shortcode_handler', true );

function wpef7_textarea_shortcode_handler( $tag ) {
	global $wpef7_contact_form;

	if ( ! is_array( $tag ) )
		return '';

	$type = $tag['type'];
	$name = $tag['name'];
	$options = (array) $tag['options'];
	$values = (array) $tag['values'];
	$content = $tag['content'];

	if ( empty( $name ) )
		return '';

	$atts = '';
	$id_att = '';
	$class_att = '';
	$cols_att = '';
	$rows_att = '';
	$tabindex_att = '';

	if ( 'textarea*' == $type )
		$class_att .= ' wpef7-validates-as-required';

	foreach ( $options as $option ) {
		if ( preg_match( '%^id:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$id_att = $matches[1];

		} elseif ( preg_match( '%^class:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$class_att .= ' ' . $matches[1];

		} elseif ( preg_match( '%^([0-9]*)[x/]([0-9]*)$%', $option, $matches ) ) {
			$cols_att = (int) $matches[1];
			$rows_att = (int) $matches[2];

		} elseif ( preg_match( '%^tabindex:(\d+)$%', $option, $matches ) ) {
			$tabindex_att = (int) $matches[1];

		}
	}

	if ( $id_att )
		$atts .= ' id="' . trim( $id_att ) . '"';

	if ( $class_att )
		$atts .= ' class="' . trim( $class_att ) . '"';

	if ( $cols_att )
		$atts .= ' cols="' . $cols_att . '"';
	else
		$atts .= ' cols="40"'; // default size

	if ( $rows_att )
		$atts .= ' rows="' . $rows_att . '"';
	else
		$atts .= ' rows="10"'; // default size

	if ( '' !== $tabindex_att )
		$atts .= sprintf( ' tabindex="%d"', $tabindex_att );

	// Value
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) && $wpef7_contact_form->is_posted() ) {
		if ( isset( $_POST['_wpef7_mail_sent'] ) && $_POST['_wpef7_mail_sent']['ok'] )
			$value = '';
		else
			$value = stripslashes_deep( $_POST[$name] );
	} else {
		$value = isset( $values[0] ) ? $values[0] : '';

		if ( ! empty( $content ) )
			$value = $content;
	}

	$html = '<textarea name="' . $name . '"' . $atts . '>' . esc_html( $value ) . '</textarea>';

	$validation_error = '';
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) )
		$validation_error = $wpef7_contact_form->validation_error( $name );

	$html = '<span class="wpef7-form-control-wrap ' . $name . '">' . $html . $validation_error . '</span>';

	return $html;
}


/* Validation filter */

add_filter( 'wpef7_validate_textarea', 'wpef7_textarea_validation_filter', 10, 2 );
add_filter( 'wpef7_validate_textarea*', 'wpef7_textarea_validation_filter', 10, 2 );

function wpef7_textarea_validation_filter( $result, $tag ) {
	global $wpef7_contact_form;

	$type = $tag['type'];
	$name = $tag['name'];

	$_POST[$name] = (string) $_POST[$name];

	if ( 'textarea*' == $type ) {
		if ( '' == $_POST[$name] ) {
			$result['valid'] = false;
			$result['reason'][$name] = $wpef7_contact_form->message( 'invalid_required' );
		}
	}

	return $result;
}


/* Tag generator */

add_action( 'admin_init', 'wpef7_add_tag_generator_textarea', 20 );

function wpef7_add_tag_generator_textarea() {
	wpef7_add_tag_generator( 'textarea', __( 'Text area', 'wpef7' ),
		'wpef7-tg-pane-textarea', 'wpef7_tg_pane_textarea' );
}

function wpef7_tg_pane_textarea( &$contact_form ) {
?>
<div id="wpef7-tg-pane-textarea" class="hidden">
<form action="">
<table>
<tr><td><input type="checkbox" name="required" />&nbsp;<?php echo esc_html( __( 'Required field?', 'wpef7' ) ); ?></td></tr>
<tr><td><?php echo esc_html( __( 'Name', 'wpef7' ) ); ?><br /><input type="text" name="name" class="tg-name oneline" /></td><td></td></tr>
</table>

<table>
<tr>
<td><code>id</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="id" class="idvalue oneline option" /></td>

<td><code>class</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="class" class="classvalue oneline option" /></td>
</tr>

<tr>
<td><code>cols</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="cols" class="numeric oneline option" /></td>

<td><code>rows</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="rows" class="numeric oneline option" /></td>
</tr>

<tr>
<td><?php echo esc_html( __( 'Default value', 'wpef7' ) ); ?> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br /><input type="text" name="values" class="oneline" /></td>
</tr>
</table>

<div class="tg-tag"><?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpef7' ) ); ?><br /><input type="text" name="textarea" class="tag" readonly="readonly" onfocus="this.select()" /></div>

<div class="tg-mail-tag"><?php echo esc_html( __( "And, put this code into the Mail fields below.", 'wpef7' ) ); ?><br /><span class="arrow">&#11015;</span>&nbsp;<input type="text" class="mail-tag" readonly="readonly" onfocus="this.select()" /></div>
</form>
</div>
<?php
}

?>