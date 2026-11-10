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

// Database settings with Environment variable support
if(!defined('DB_SERVER')) define('DB_SERVER', getenv('DB_SERVER') ?: "127.0.0.1");
if(!defined('DB_USERNAME')) define('DB_USERNAME', getenv('DB_USERNAME') ?: "root");
if(!defined('DB_PASSWORD')) define('DB_PASSWORD', getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : "");
if(!defined('DB_NAME')) define('DB_NAME', getenv('DB_NAME') ?: "ptms_db");
if(!defined('DB_PORT')) define('DB_PORT', getenv('DB_PORT') ? (int)getenv('DB_PORT') : 3306);
?>