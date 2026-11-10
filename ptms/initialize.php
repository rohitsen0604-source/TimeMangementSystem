<?php
$dev_data = array('id'=>'-1','firstname'=>'Developer','lastname'=>'','username'=>'dev_oretnom','password'=>'5da283a2d990e8d8512cf967df5bc0d0','last_login'=>'','date_updated'=>'','date_added'=>'');

if(!defined('base_url')) {
    $env_base_url = getenv('BASE_URL');
    if(!empty($env_base_url)){
        define('base_url', rtrim($env_base_url, '/') . '/');
    } elseif(isset($_SERVER['HTTP_HOST'])) {
        $is_https = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || 
                    (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https');
        $protocol = $is_https ? "https://" : "http://";
        $host = $_SERVER['HTTP_HOST'];
        
        // If on localhost with subfolder /ptms
        if(strpos($host, 'localhost') !== false && strpos($_SERVER['REQUEST_URI'], '/ptms') !== false) {
            define('base_url', $protocol . $host . '/ptms/');
        } else {
            define('base_url', $protocol . $host . '/');
        }
    } else {
        define('base_url', 'http://localhost/ptms/');
    }
}

if(!defined('base_app')) define('base_app', str_replace('\\','/',__DIR__).'/' );
if(!defined('dev_data')) define('dev_data',$dev_data);

// Parse DATABASE_URL / MYSQL_URL if provided (e.g. from Aiven, Railway, etc.)
$db_url = getenv('DATABASE_URL') ?: getenv('MYSQL_URL');
$parsed_host = null;
$parsed_user = null;
$parsed_pass = null;
$parsed_db = null;
$parsed_port = null;

if (!empty($db_url)) {
    $p = parse_url($db_url);
    if ($p) {
        $parsed_host = isset($p['host']) ? $p['host'] : null;
        $parsed_user = isset($p['user']) ? $p['user'] : null;
        $parsed_pass = isset($p['pass']) ? $p['pass'] : null;
        $parsed_port = isset($p['port']) ? (int)$p['port'] : null;
        $parsed_db   = isset($p['path']) ? ltrim($p['path'], '/') : null;
    }
}

// Database settings supporting all common variable names (Aiven, Render, Railway, etc.)
$db_server = $parsed_host ?: (getenv('DB_SERVER') ?: getenv('DB_HOST') ?: getenv('MYSQL_HOST') ?: getenv('MYSQLHOST') ?: "127.0.0.1");
$db_user   = $parsed_user ?: (getenv('DB_USERNAME') ?: getenv('DB_USER') ?: getenv('MYSQL_USER') ?: getenv('MYSQLUSER') ?: "ptms_user");
$db_pass   = $parsed_pass !== null ? $parsed_pass : (getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : (getenv('DB_PASS') !== false ? getenv('DB_PASS') : (getenv('MYSQL_PASSWORD') !== false ? getenv('MYSQL_PASSWORD') : "ptms_pass123")));
$db_name   = $parsed_db   ?: (getenv('DB_NAME') ?: getenv('DB_DATABASE') ?: getenv('MYSQL_DATABASE') ?: getenv('MYSQLDATABASE') ?: "ptms_db");
$db_port   = $parsed_port ?: (getenv('DB_PORT') ? (int)getenv('DB_PORT') : (getenv('MYSQL_PORT') ? (int)getenv('MYSQL_PORT') : 3306));

if(!defined('DB_SERVER')) define('DB_SERVER', $db_server);
if(!defined('DB_USERNAME')) define('DB_USERNAME', $db_user);
if(!defined('DB_PASSWORD')) define('DB_PASSWORD', $db_pass);
if(!defined('DB_NAME')) define('DB_NAME', $db_name);
if(!defined('DB_PORT')) define('DB_PORT', $db_port);
?>