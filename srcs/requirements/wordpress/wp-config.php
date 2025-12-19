<?php

define('DB_NAME', getenv('MARIADB_DATABASE'));
define('DB_USER', getenv('MARIADB_USER'));
define('DB_PASSWORD', getenv('MARIADB_PASSWORD'));
define('DB_HOST', getenv('MARIADB_HOST') . ':' . getenv('MARIADB_PORT'));

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('WP_DEBUG', false);
