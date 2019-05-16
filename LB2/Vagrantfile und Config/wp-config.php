<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', 'wordpress' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

define('FS_METHOD', 'direct');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '!ta+0sv-5fMp+IPQf-Hs1!|+Za5L|U42tn zG2Rk@5|>$7sVoX]pxaO(X#O2URa?');
define('SECURE_AUTH_KEY',  'w`R>IF1uiy5D5g,Au(`~+.]u>y)d|c+&70_65kdj_.iGO@~XRUarx6G#o)[_ *h<');
define('LOGGED_IN_KEY',    's6dL|+aq0$;5Y&0v5zEnYhn-!@{.nx&[-LDZ3:P.r-AxZ+YJBY!-oYSaB6Gv+F7?');
define('NONCE_KEY',        'riJpyN}K@{&~fD90|,kJcV6.19yGQ!+ja!&r6R1)qE3_5-eXA-osx{R7h~7V!jP~');
define('AUTH_SALT',        'F<3?mr_bd!.^#+u n2T|t}_sqGP%;{$fCF@JkgfvWlkS$rZbZvn>-Cg*MNbd`E#R');
define('SECURE_AUTH_SALT', 'ub?zbFw]ej$4_=Rf&w`. jVk&`[Gu&D!=hE}#N&t`hE|3uB,#(NEYg$@))x7/5j{');
define('LOGGED_IN_SALT',   'ChkK|55{no%U&rI+RfXzV6r-/i&l_(-{%xzFR@gipkwY@l;NY@pp0^vpT?-O?;Ec');
define('NONCE_SALT',       'e+Qs.4qBJc4*}$d~u-Y:AWXA+$DIUYo nNDU ,*8(gi[3Z] v>l.>R3HG0||(`1:');
/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
