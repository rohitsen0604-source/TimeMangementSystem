<?php 
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
$is_https = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || 
            (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https');
$link = $is_https ? "https" : "http"; 
$link .= "://"; 
$link .= isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : 'localhost'; 
$link .= isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '';

if(!isset($_SESSION['userdata']) && !strpos($link, 'login.php') && !strpos($link, 'register.php')){
	redirect('admin/login.php');
}
if(isset($_SESSION['userdata']) && strpos($link, 'login.php')){
	redirect('admin/index.php');
}
if(isset($_SESSION['userdata']) && (strpos($link, 'index.php') || strpos($link, 'admin/')) && (!isset($_SESSION['userdata']['login_type']) || $_SESSION['userdata']['login_type'] != 1)){
	echo "<script>alert('Access Denied!');location.replace('".base_url."');</script>";
    exit;
}
?>
